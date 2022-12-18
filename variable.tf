variable "region" {
    type = string 
    description = "aws region for resources to be deployed"
}

variable "name" { 
    type = string 
    description = "name of Ec2 instance "
}

variable "image_id" { 
    type = string 
    description = "the ami type of instance to be deployed"
}

variable "instance_type" { 
    type = string 
    description = "size of instance to be deployed"
}

variable "key_name" { 
    type = string 
    description = "name of the key pair to be used"
} 

variable "user_data" {
    type = string
    description = "name of user data file"
}
# variable "private_key" { type = string }

variable "asg_min_size" { 
    type = number 
    description = "auto scaling group minimum size"
}

variable "asg_max_size" { 
    type = number
    description = "auto scaling group maximum size" 
}

variable "asg_desired_capacity" { 
    type = number 
    description = "auto scaling group desired capacity"
}

variable "enabled_metrics" { 
    type = list(string)
    description = "autoscaling enabled metrics"
}

variable "metrics_granularity" { 
    type = string
    description = "auto scaling metrics granularity" 
}

# Defining CIDR Block for VPC
variable "vpc_cidr" { 
    type = string
    description = "CIDR block for the vpc" 
}

# Defining CIDR Block for Subnet
variable "subnet_cidr" { 
    type = string
    description = "CIDR block for the first subnet"
}

variable "subnet_availability_zone" { 
    type = string
    description = "Availability zone for the first subnet"
}

# Defining CIDR Block for 2d Subnet
variable "subnet1_cidr" { 
    type = string 
    description = "CIDR block for the second subnet"
}

variable "subnet1_availability_zone" {
    type = string
    description = "availabilty zone for the second subnet"
}

# Defining policy up configurations
variable "policy_up_scaling_adjustment" {
    type = number
    description = "aws policy up scaling adjustment" 
}

variable "policy_up_ajustment_type" { 
    type = string
    description = "aws policy up adjustment type"
}

variable "policy_up_cooldown" { 
    type = number
    description = "aws policy up cooldown"
}

# Defining alarm up configurations
variable "alarm_up_comparison_operator" {
    type = string
    description = "aws alarm up comparison operator"
}

variable "alarm_up_evaluation_periods" {
    type = string 
    description = "aws alarm up evalaution periods"    
}

variable "alarm_up_metric_name" {
    type = string
    description = "aws alarm up metric name"
}

variable "alarm_up_namespace" {
    type = string
    description = "aws alarm up namespace"
}

variable "alarm_up_period" {
    type = string 
    description = "aws alarm up period"
}

variable "alarm_up_statistic" {
    type = string
    description = "aws alarm up statistics"
}

variable "alarm_up_threshold" {
    type = string 
    description = "aws alarm up threshold"
}

# Defining policy down configurations
variable "policy_down_scaling_adjustment" { 
    type = number 
    description = "aws policy down scaling adjustment"
}

variable "policy_down_ajustment_type" {
    type = string 
    description = "aws policy down adjustment"
}

variable "policy_down_cooldown" {
    type = number 
    description = "aws policy down cooldown"
}

# Defining alarm down configurations
variable "alarm_down_comparison_operator" {
    type = string 
    description = "aws alarm down comparison operator"
}

variable "alarm_down_evaluation_periods" {
    type = string 
    description = "aws alarm down evaluation periods"
}

variable "alarm_down_metric_name" {
    type = string 
    description = "aws alarm down metric name"    
}

variable "alarm_down_namespace" {
    type = string 
    description = "aws alarm down namespace"
}

variable "alarm_down_period" {
    type = string 
    description = "aws alarm down period"
}

variable "alarm_down_statistic" {
    type = string 
    description = "aws alarm down statistics"
}

variable "alarm_down_threshold" {
    type = string 
    description = "aws alarm down threshold"
}