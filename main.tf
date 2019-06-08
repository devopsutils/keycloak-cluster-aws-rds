provider "aws" {
    region = "${var.aws_region}"
}

module "vpc" {
  source = "./vpc"

  admin_cidr_ingress = "${var.admin_cidr_ingress}"

}

module "cloudwatch" {
  source = "./cloudwatch"
}

module "iam" {
  source = "./iam"

  app_log_group_arn = "${module.cloudwatch.app_log_group_arn}"
  ecs_log_group_arn = "${module.cloudwatch.ecs_log_group_arn}"
}

module "ec2" {
  source = "./ec2"

  aws_region = "${var.aws_region}"
  key_name = "${var.key_name}"
  ecs_log_level = "${var.ecs_log_level}"
  ecs_cluster_name = "${var.ecs_cluster_name}"
  vpc_zone_identifier = "${module.vpc.vpc_zone_identifier}"
  app_iam_instance_profile_name = "${module.iam.app_iam_instance_profile_name}"
  instance_sg_id = "${module.vpc.instance_sg_id}"
  ecs_log_group_name = "${module.cloudwatch.ecs_log_group_name}"
}

module "alb" {
  source = "./alb"

  vpc_id = "${module.vpc.vpc_id}"
  subnet_ids = "${module.vpc.public_subnet_ids}"
  security_groups = "${module.vpc.security_groups}"
  certificate_arn = "${module.dns.acm_certificate_arn}"

}

module "rds" {
  source = "./rds"

  vpc_id = "${module.vpc.vpc_id}"
  public_subnet_ids = "${module.vpc.public_subnet_ids}"
  private_subnet_ids = "${module.vpc.private_subnet_ids}"
  public_subnet_cidr = "${module.vpc.public_subnet_cidr}"
  private_subnet_cidr = "${module.vpc.private_subnet_cidr}"
  instance_security_group = "${module.vpc.instance_sg_id}"
}

module "ecr" {
  source = "./ecr"

  aws_region = "${var.aws_region}"
}

module "ecs" {
  source = "./ecs"

  docker_image_url = "${module.ecr.ecr_repo_url}:latest"
  keycloak_admin_username = "${var.keycloak_admin_username}"
  keycloak_admin_password = "${var.keycloak_admin_password}"
  app_log_group_name = "${module.cloudwatch.app_log_group_name}"
  aws_region = "${var.aws_region}"
  ecs_iam_role_name = "${module.iam.ecs_iam_role_name}"
  ecs_iam_role_arn = "${module.iam.ecs_iam_role_arm}"
  alb_target_group_arn = "${module.alb.alb_target_group_arn}"
  ecs_cluster_name = "${var.ecs_cluster_name}"
  ecs_service_iam_role_policy = "${module.iam.ecs_service_iam_role_policy}"
  alb_listener_front_end = "${module.alb.alb_listener_front_end_tls}"
  
  database_hostname = "${module.rds.database_hostname}"
  database_port = "${module.rds.database_port}"
  database_name = "${module.rds.database_name}"
  database_username = "${module.rds.database_username}"
  database_password = "${module.rds.database_password}"
}

module "dns" {
  source = "./dns"

  zone_name = "${var.zone_name}"
  public_dns_name = "${var.public_dns_name}"
  alb_dns_name = "${module.alb.alb_dns_name}"
  alb_zone_id = "${module.alb.alb_zone}"
}

