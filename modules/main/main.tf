terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.47.0"
    }
  }
}

provider "aws" {
    region = var.region
}

resource "aws_launch_configuration" "app" {
  name = "${var.name}"
  image_id = "${var.image_id}" 
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  security_groups = [ "${aws_security_group.appsg.id}" ]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data = "${file(var.user_data)}"

  lifecycle {
    create_before_destroy = true
  }
}

# auto-scaling group configuration
resource "aws_autoscaling_group" "app" {
  name = "${aws_launch_configuration.app.name}-asg"

  min_size             = "${var.asg_min_size}"
  desired_capacity     = "${var.asg_desired_capacity}"
  max_size             = "${var.asg_max_size}"
  
  health_check_type    = "ELB"
  load_balancers = [
    "${aws_elb.app_elb.id}"
  ]

  launch_configuration = "${aws_launch_configuration.app.name}"

  enabled_metrics = "${var.enabled_metrics}"

  metrics_granularity = "${var.metrics_granularity}"

  vpc_zone_identifier  = [
    "${aws_subnet.appsubnet.id}",
    "${aws_subnet.appsubnet1.id}"
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "app"
    propagate_at_launch = true
  }

}

#Creating VPC
resource "aws_vpc" "appvpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "${var.instance_tenancy}"
  tags             = "${var.vpc-tags}"
}


# load balancer configuration
resource "aws_elb" "app_elb" {
  name = "${aws_launch_configuration.app.name}-elb"
  security_groups = [
    "${aws_security_group.appsg1.id}"
  ]
  subnets = [
    "${aws_subnet.appsubnet.id}",
    "${aws_subnet.appsubnet1.id}"
  ]
  cross_zone_load_balancing = "${var.app_elb_cross_zone_load_balancing}"

  health_check {
    healthy_threshold = "${var.app_elb_health_check_healthy_threshold}"
    unhealthy_threshold = "${var.app_elb_health_check_unhealthy_threshold}"
    timeout = "${var.app_elb_health_check_timeout}"
    interval = "${var.app_elb_health_check_interval}"
    target = "${var.app_elb_health_check_target}"
  }

  listener {
    lb_port = "${var.app_elb_listener_lb_port}"
    lb_protocol = "${var.app_elb_listener_lb_protocol}"
    instance_port = "${var.app_elb_listener_instance_port}"
    instance_protocol = "${var.app_elb_listener_instance_protocol}"
  }
}


# Creating Internet Gateway 
resource "aws_internet_gateway" "appgateway" {
  vpc_id = "${aws_vpc.appvpc.id}"
}
# Creating 1st subnet 
resource "aws_subnet" "appsubnet" {
  vpc_id                  = "${aws_vpc.appvpc.id}"
  cidr_block              = "${var.subnet_cidr}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.subnet_availability_zone}"

  tags = {
    Name = "app subnet"
  }
}

# Creating 2nd subnet 
resource "aws_subnet" "appsubnet1" {
  vpc_id                  = "${aws_vpc.appvpc.id}"
  cidr_block              = "${var.subnet1_cidr}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.subnet1_availability_zone}"

  tags = {
    Name = "app subnet 1"
  }
}

#Creating Route Table
resource "aws_route_table" "route" {
  vpc_id                  = "${aws_vpc.appvpc.id}"

  route {
        cidr_block = var.route_cidr_block
        gateway_id = "${aws_internet_gateway.appgateway.id}"
    }

  tags = "${var.route_tags}"
}

resource "aws_route_table_association" "rt1" {
    subnet_id = "${aws_subnet.appsubnet.id}"
    route_table_id = "${aws_route_table.route.id}"
}

resource "aws_route_table_association" "rt2" {
    subnet_id = "${aws_subnet.appsubnet1.id}"
    route_table_id = "${aws_route_table.route.id}"
}

resource "aws_autoscaling_policy" "app_policy_up" {
  name = "${aws_launch_configuration.app.name}_policy_up"
  scaling_adjustment = "${var.policy_up_scaling_adjustment}"
  adjustment_type = "${var.policy_up_ajustment_type}"
  cooldown = "${var.policy_up_cooldown}"
  autoscaling_group_name = "${aws_autoscaling_group.app.name}"
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_up" {
  alarm_name = "${aws_launch_configuration.app.name}_cpu_alarm_up"
  comparison_operator = "${var.alarm_up_comparison_operator}"
  evaluation_periods = "${var.alarm_up_evaluation_periods}"
  metric_name = "${var.alarm_up_metric_name}"
  namespace = "${var.alarm_up_namespace}"
  period = "${var.alarm_up_period}"
  statistic = "${var.alarm_up_statistic}"
  threshold = "${var.alarm_up_threshold}"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.app.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.app_policy_up.arn}" ]
}

resource "aws_autoscaling_policy" "app_policy_down" {
  name = "${aws_launch_configuration.app.name}_policy_down"
  scaling_adjustment = "${var.policy_down_scaling_adjustment}"
  adjustment_type = "${var.policy_down_ajustment_type}"
  cooldown = "${var.policy_down_cooldown}"
  autoscaling_group_name = "${aws_autoscaling_group.app.name}"
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_down" {
  alarm_name = "${aws_launch_configuration.app.name}_cpu_alarm_down"
  comparison_operator = "${var.alarm_down_comparison_operator}"
  evaluation_periods = "${var.alarm_down_evaluation_periods}"
  metric_name = "${var.alarm_down_metric_name}"
  namespace = "${var.alarm_down_namespace}"
  period = "${var.alarm_down_period}"
  statistic = "${var.alarm_down_statistic}"
  threshold = "${var.alarm_down_threshold}"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.app.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.app_policy_down.arn}" ]
}

resource "aws_security_group" "appsg" {

  vpc_id                  = "${aws_vpc.appvpc.id}"

  # Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating Security Group for ELB
resource "aws_security_group" "appsg1" {
  name        = "App Security Group"
  description = "App Module"
  vpc_id      = "${aws_vpc.appvpc.id}"

  # Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
