resource "aws_ecr_repository" "main" {
  name = "${var.ecr_repository_name}"
}

resource "null_resource" "build_docker_image" {
  
  provisioner "local-exec" {
    command = "docker image build -t ${var.docker_image_name}:${var.docker_image_tag} ."
    # command = "docker image build -t ${aws_ecr_repository.main.repository_url}/${var.docker_image_name}:${var.docker_image_tag} ."
    working_dir = "${dirname("${path.module}/resources/Dockerfile")}"
  }
}

resource "null_resource" "tag_and_push_docker_image" {

  provisioner "local-exec" {
    command = "sh ./image_push.sh ${var.aws_region} ${var.docker_image_name}:${var.docker_image_tag} ${aws_ecr_repository.main.repository_url}"
    working_dir = "${dirname("${path.module}/resources/image_push.sh")}"
  }

  depends_on = ["null_resource.build_docker_image"]
}
