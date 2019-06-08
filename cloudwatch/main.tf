resource "aws_cloudwatch_log_group" "ecs" {
  name = "${var.ecs_log_group_name}"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "${var.app_log_group_name}"
}
