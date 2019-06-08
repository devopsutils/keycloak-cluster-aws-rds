variable "ecs_desired_instances" {
  description = "The desired number of instances for ECS"
  default     = "1"
}

variable "container_name" {
  description = "The name of the ECS container"
  default = "keycloak"
}

variable "docker_image_url" {}

variable "docker_container_port" {
  description = "The Docker container port"
  default = 8080
}

variable "docker_host_port" {
  description = "The Docker host port"
  default = 0
}

variable "ecs_cluster_name" {}

variable "ecs_task_family" {
  description = "The ECS task family name"
  default = "keycloak_task_family"
}

variable "keycloak_admin_username" {
  description = "KeyCloak Admin Username"
}

variable "keycloak_admin_password" {
  description = "KeyCloak Admin Password"
}

variable "app_log_group_name" {}

variable "aws_region" {}

variable "ecs_iam_role_name" {}

variable "ecs_iam_role_arn" {}

variable "alb_target_group_arn" {}

variable "ecs_service_iam_role_policy" {}

variable "alb_listener_front_end" {}

variable "database_hostname" {}

variable "database_port" {}

variable "database_name" {}

variable "database_username" {}

variable "database_password" {}
