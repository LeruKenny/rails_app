variable "region" { type = string }

variable "name" { type = string }

variable "image_id" { type = string }

variable "instance_type" { type = string }

variable "key_name" { type = string } 

variable "private_key" { type = string }

variable "asg_min_size" { type = number }

variable "asg_max_size" { type = number }

variable "asg_desired_capacity" { type = number }

variable "enabled_metrics" { type = list(string)}

variable "metrics_granularity" { type = string }

# Defining CIDR Block for VPC
variable "vpc_cidr" { type = string }

# Defining CIDR Block for Subnet
variable "subnet_cidr" { type = string}

variable "subnet_availability_zone" { type = string }

# Defining CIDR Block for 2d Subnet
variable "subnet1_cidr" { type = string }

variable "subnet1_availability_zone" { type = string }

# Defining policy up configurations
variable "policy_up_scaling_adjustment" { type = number }

variable "policy_up_ajustment_type" { type = string }

variable "policy_up_cooldown" { type = number }

variable "alarm_up_comparison_operator" { type = string }

variable "alarm_up_evaluation_periods" {type = string }

variable "alarm_up_metric_name" {type = string }

variable "alarm_up_namespace" {type = string }

variable "alarm_up_period" {type = string }

variable "alarm_up_statistic" {type = string }

variable "alarm_up_threshold" {type = string }

# Defining policy down configurations
variable "policy_down_scaling_adjustment" { type = number }

variable "policy_down_ajustment_type" { type = string }

variable "policy_down_cooldown" { type = number }

variable "alarm_down_comparison_operator" { type = string }

variable "alarm_down_evaluation_periods" {type = string }

variable "alarm_down_metric_name" {type = string }

variable "alarm_down_namespace" {type = string }

variable "alarm_down_period" {type = string }

variable "alarm_down_statistic" {type = string }

variable "alarm_down_threshold" {type = string }