variable "ecr_repository_name" {
  description = "Name of the ECR Repository"
  default = "keycloak"
}

variable "docker_image_name" {
  description = "Name of the Docker Image"
  default = "keycloak-custom"
}

variable "docker_image_tag" {
  description = "The Version Tag for the Docker Image"
  default = "6.0.1"
}

variable "aws_region" {}
