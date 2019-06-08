resource "aws_iam_role" "ecs_service" {
  name = "ecs_service_role"

  assume_role_policy = "${file("iam/resources/ecs_service_role.json")}"
}

resource "aws_iam_role_policy" "ecs_service" {
  name = "ecs_service_role_policy"
  role = "${aws_iam_role.ecs_service.name}"

  policy = "${file("iam/resources/ecs_service_role_policy.json")}"
}

resource "aws_iam_instance_profile" "app" {
  name = "ecs_app_instance_profile"
  role = "${aws_iam_role.app_instance.name}"
}

resource "aws_iam_role" "app_instance" {
  name = "ecs_app_instance_role"

  assume_role_policy = "${file("iam/resources/ecs_instance_role.json")}"
}

data "template_file" "instance_profile" {
  template = "${file("iam/templates/instance-profile-policy.tpl")}"

  vars = {
    app_log_group_arn = "${var.app_log_group_arn}"
    ecs_log_group_arn = "${var.ecs_log_group_arn}"
  }
}

resource "aws_iam_role_policy" "instance" {
  name   = "ecs_instance_role_policy"
  role   = "${aws_iam_role.app_instance.name}"
  policy = "${data.template_file.instance_profile.rendered}"
}
