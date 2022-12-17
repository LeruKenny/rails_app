region = "us-east-1"
name = "rails"
image_id = "ami-0574da719dca65348"
instance_type = "t2.micro"
key_name = "test1"

asg_desired_capacity = 2
asg_min_size = 1
asg_max_size = 2
enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
]
metrics_granularity = "1Minute"

vpc_cidr = "10.0.0.0/16"

subnet_cidr = "10.0.1.0/24"
subnet1_cidr = "10.0.2.0/24"
subnet_availability_zone = "us-east-1a"
subnet1_availability_zone = "us-east-1b"

policy_up_scaling_adjustment = 1
policy_up_cooldown = 300
policy_up_ajustment_type = "ChangeInCapacity"

policy_down_scaling_adjustment = -1
policy_down_cooldown = 300
policy_down_ajustment_type = "ChangeInCapacity"

alarm_up_comparison_operator = "GreaterThanOrEqualToThreshold"
alarm_up_evaluation_periods = "2"
alarm_up_metric_name = "CPUUtilization"
alarm_up_namespace = "AWS/EC2"
alarm_up_period = "120"
alarm_up_statistic = "Average"
alarm_up_threshold = "70"

alarm_down_comparison_operator = "LessThanOrEqualToThreshold"
alarm_down_evaluation_periods = "2"
alarm_down_metric_name = "CPUUtilization"
alarm_down_namespace = "AWS/EC2"
alarm_down_period = "120"
alarm_down_statistic = "Average"
alarm_down_threshold = "30"