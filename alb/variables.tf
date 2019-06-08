variable "alb_port" {
    description = "The port the ALB should listen on"
    default = 80
}

variable "alb_target_port" {
    description = "The port the ALB should connect to backend services on on"
    default = 8080
}

variable "alb_protocol" {
    description = "The protocol for the ALB"
    default = "HTTP"
}

variable "alb_target_group_name" {
    description = "The name for the ALB target group"
    default = "keycloak-target-group"
}

variable "alb_name" {
    description = "The name for the ALB"
    default = "keycloak-alb"
}

variable "vpc_id" {}

variable "subnet_ids" {}

variable "security_groups" {}

variable "certificate_arn" {}
