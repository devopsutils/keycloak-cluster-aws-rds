variable "aws_region" {
  description = "The AWS region for creating the infrastructure"
  default = "us-east-1"
}

variable "key_name" {
  description = "Name of the AWS key pair to use"
}

variable "ecs_cluster_name" {
  default = "ecs_cluster"
}

variable "ecs_log_level" {
  description = "The ECS log level"
  default = "info"
}

variable "admin_cidr_ingress" {
  
}

variable "keycloak_admin_username" {
  description = "KeyCloak Admin Username"
}

variable "keycloak_admin_password" {
  description = "KeyCloak Admin Password"
}

variable "public_dns_name" {
  description = "The public-facing DNS name"
}

variable "zone_name" {
  description = "The DNS zone name"
}
