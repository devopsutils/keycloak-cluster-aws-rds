resource "aws_ecs_cluster" "main" {
  name = "${var.ecs_cluster_name}"
}

data "template_file" "task_definition" {
  template = "${file("${path.module}/templates/task-definition.tpl")}"

  vars = {
    image_url        = "${var.docker_image_url}"
    container_name   = "${var.container_name}"
    log_group_region = "${var.aws_region}"
    log_group_name   = "${var.app_log_group_name}"
    container_port = "${var.docker_container_port}"
    host_port = "${var.docker_host_port}"
    keycloak_admin_username = "${var.keycloak_admin_username}"
    keycloak_admin_password = "${var.keycloak_admin_password}"
    database_hostname = "${var.database_hostname}"
    database_port = "${var.database_port}"
    database_name = "${var.database_name}"
    database_username = "${var.database_username}"
    database_password = "${var.database_password}"

  }
}

resource "aws_ecs_task_definition" "main" {
  family                = "${var.ecs_task_family}"
  container_definitions = "${data.template_file.task_definition.rendered}"
}

resource "aws_ecs_service" "main" {
  name            = "ecs_service"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.main.arn}"
  desired_count   = "${var.ecs_desired_instances}"
  iam_role        = "${var.ecs_iam_role_name}"

  load_balancer {
    target_group_arn = "${var.alb_target_group_arn}"
    container_name   = "${var.container_name}"
    container_port   = "${var.docker_container_port}"
  }

  depends_on = [
    "var.alb_listener_front_end",
    "var.ecs_service_iam_role_policy"
  ]
}

resource "aws_appautoscaling_target" "ecs_auto_scaling_target" {
  min_capacity = 2
  max_capacity = 4
  resource_id = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  role_arn = "${var.ecs_iam_role_arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "up" {
  name               = "scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = ["aws_appautoscaling_target.ecs_auto_scaling_target"]
}

resource "aws_appautoscaling_policy" "down" {
  name               = "scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = ["aws_appautoscaling_target.ecs_auto_scaling_target"]
}

resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "8"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.main.name}"
    ServiceName = "${aws_ecs_service.main.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.up.arn}"]
}

# Cloudwatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "8"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.main.name}"
    ServiceName = "${aws_ecs_service.main.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.down.arn}"]
}