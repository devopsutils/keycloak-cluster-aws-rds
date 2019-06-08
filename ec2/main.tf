data "aws_ami" "stable_coreos" {
    most_recent = true

    filter {
        name   = "description"
        values = ["CoreOS Container Linux stable *"]
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["595879546273"]
}

resource "aws_autoscaling_group" "app" {
    name                 = "${var.autoscaling_group_name}"
    vpc_zone_identifier = "${var.vpc_zone_identifier}"
    min_size             = "${var.autoscaling_min_size}"
    max_size             = "${var.autoscaling_max_size}"
    desired_capacity     = "${var.autoscaling_desired_size}"
    launch_configuration = "${aws_launch_configuration.app.name}"
}

data "template_file" "cloud_config" {
    template = "${file("ec2/templates/cloud-config.tpl")}"

    vars = {
        aws_region         = "${var.aws_region}"
        ecs_cluster_name   = "${var.ecs_cluster_name}"
        ecs_log_level      = "${var.ecs_log_level}"
        ecs_agent_version  = "latest"
        ecs_log_group_name = "${var.ecs_log_group_name}"
    }
}

resource "aws_launch_configuration" "app" {
    security_groups = [
        "${var.instance_sg_id}",
    ]

    key_name                    = "${var.key_name}"
    image_id                    = "${data.aws_ami.stable_coreos.id}"
    instance_type               = "${var.instance_type}"
    iam_instance_profile = "${var.app_iam_instance_profile_name}"
    user_data                   = "${data.template_file.cloud_config.rendered}"
    associate_public_ip_address = true

    lifecycle {
        create_before_destroy = true
    }
}

resource "tls_private_key" "genkey" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "genkey" {
    key_name = "${var.key_name}"
    public_key = "${tls_private_key.genkey.public_key_openssh}"
}
