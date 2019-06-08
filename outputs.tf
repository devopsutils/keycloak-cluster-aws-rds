output "alb_public_dns" {
    value = "${module.alb.alb_dns_name}"
}

output "public_dns_name" {
    value = "${var.public_dns_name}"
}

output "ecr_repository_url" {
  value = "${module.ecr.ecr_repo_url}"
}

output "docker_image_name" {
  value = "${module.ecr.docker_image_name}"
}
