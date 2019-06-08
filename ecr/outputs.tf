output "ecr_repo_url" {
  value = "${aws_ecr_repository.main.repository_url}"
}

output "docker_image_name" {
  value = "${var.docker_image_name}:${var.docker_image_tag}"
}