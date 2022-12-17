resource "aws_autoscaling_policy" "app_policy_up" {
  name = "${aws_launch_configuration.app.name}_policy_up"
  scaling_adjustment = var.policy_up_scaling_adjustment
  adjustment_type = var.policy_up_ajustment_type
  cooldown = var.policy_up_cooldown
  autoscaling_group_name = "${aws_autoscaling_group.app.name}"
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_up" {
  alarm_name = "${aws_launch_configuration.app.name}_cpu_alarm_up"
  comparison_operator = var.alarm_up_comparison_operator
  evaluation_periods = var.alarm_up_evaluation_periods
  metric_name = var.alarm_up_metric_name
  namespace = var.alarm_up_namespace
  period = var.alarm_up_period
  statistic = var.alarm_up_statistic
  threshold = var.alarm_up_threshold

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.app.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.app_policy_up.arn}" ]
}

resource "aws_autoscaling_policy" "app_policy_down" {
  name = "${aws_launch_configuration.app.name}_policy_down"
  scaling_adjustment = var.policy_down_scaling_adjustment
  adjustment_type = var.policy_down_ajustment_type
  cooldown = var.policy_down_cooldown
  autoscaling_group_name = "${aws_autoscaling_group.app.name}"
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_down" {
  alarm_name = "${aws_launch_configuration.app.name}_cpu_alarm_down"
  comparison_operator = var.alarm_down_comparison_operator
  evaluation_periods = var.alarm_down_evaluation_periods
  metric_name = var.alarm_down_metric_name
  namespace = var.alarm_down_namespace
  period = var.alarm_down_period
  statistic = var.alarm_down_statistic
  threshold = var.alarm_down_threshold

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.app.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ "${aws_autoscaling_policy.app_policy_down.arn}" ]
}
