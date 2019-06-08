variable "instance_type" {
  description = "The ECS instance type"
  default     = "t2.medium"
}

variable "autoscaling_group_name" {
  description = "The name for the autoscaling group"
  default = "asg-keycloak"
}
variable "autoscaling_min_size" {
  description = "The minimum number of servers in the autoscaling group"
  default     = "2"
}

variable "autoscaling_max_size" {
  description = "The maximum number of servers in the autoscaling group"
  default     = "4"
}

variable "autoscaling_desired_size" {
  description = "The desired number of servers in the autoscaling group"
  default     = "2"
}

variable "key_name" {}

variable "aws_region" {}

variable "ecs_log_level" {}

variable "ecs_cluster_name" {}

variable "vpc_zone_identifier" {}

variable "app_iam_instance_profile_name" {}

variable "instance_sg_id" {}

variable "ecs_log_group_name" {}