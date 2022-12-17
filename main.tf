# lauch config for EC2 instance 
resource "aws_launch_configuration" "app" {
  name = var.name

  image_id = var.image_id 
  instance_type = var.instance_type
  key_name = var.key_name

  security_groups = [ "${aws_security_group.appsg.id}" ]
  associate_public_ip_address = true
  user_data = "${file("data.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

# auto-scaling group configuration
resource "aws_autoscaling_group" "app" {
  name = "${aws_launch_configuration.app.name}-asg"

  min_size             = var.asg_min_size
  desired_capacity     = var.asg_desired_capacity
  max_size             = var.asg_max_size
  
  health_check_type    = "ELB"
  load_balancers = [
    "${aws_elb.app_elb.id}"
  ]

  launch_configuration = "${aws_launch_configuration.app.name}"

  enabled_metrics = var.enabled_metrics

  metrics_granularity = var.metrics_granularity

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
  instance_tenancy = "default"

  tags = {
    Name = "App VPC"
  }
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

  cross_zone_load_balancing   = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }

}

# Creating Internet Gateway 
resource "aws_internet_gateway" "appgateway" {
  vpc_id = "${aws_vpc.appvpc.id}"
}

# Creating 1st subnet 
resource "aws_subnet" "appsubnet" {
  vpc_id                  = "${aws_vpc.appvpc.id}"
  cidr_block             = "${var.subnet_cidr}"
  map_public_ip_on_launch = true
  availability_zone = var.subnet_availability_zone

  tags = {
    Name = "app subnet"
  }
}

# Creating 2nd subnet 
resource "aws_subnet" "appsubnet1" {
  vpc_id                  = "${aws_vpc.appvpc.id}"
  cidr_block             = "${var.subnet1_cidr}"
  map_public_ip_on_launch = true
  availability_zone = var.subnet1_availability_zone

  tags = {
    Name = "app subnet 1"
  }
}

#Creating Route Table
resource "aws_route_table" "route" {
    vpc_id = "${aws_vpc.appvpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.appgateway.id}"
    }

    tags = {
        Name = "Route to internet"
    }
}

resource "aws_route_table_association" "rt1" {
    subnet_id = "${aws_subnet.appsubnet.id}"
    route_table_id = "${aws_route_table.route.id}"
}

resource "aws_route_table_association" "rt2" {
    subnet_id = "${aws_subnet.appsubnet1.id}"
    route_table_id = "${aws_route_table.route.id}"
}

