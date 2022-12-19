region = "us-east-1"

name = "rails"
image_id = "ami-0574da719dca65348"
instance_type = "t2.micro"
key_name = ""
security_group_id = "aws_security_group.appsg.id"
user_data = "data.sh"

asg_min_size = 1
asg_desired_capacity = 2
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
instance_tenancy = "default"
vpc-tags = {
  Name = "App VPC"
}

vpc_id  = "aws_vpc.appvpc.id"

subnet_cidr = "10.0.1.0/24"
subnet_availability_zone = "us-east-1a"
subnet1_cidr = "10.0.2.0/24"
subnet1_availability_zone = "us-east-1b"

route_cidr_block  = "0.0.0.0/0"

route_tags = {
  Name = "Route to internet"
}
