variable "availability_zone_count" {
  description = "The number of availability zones to be leveraged within the VPC"
  default     = "2"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC to use"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "The CIDR block for the public subnet within the VPC"
  default = "10.0.0.0/24"
}

variable "private_subnet_cidr_block" {
  description = "The CIDR block for the private subnet within the VPC"
  default = "10.0.10.0/24"
}

variable "admin_cidr_ingress" {}
