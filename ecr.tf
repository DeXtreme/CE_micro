data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "repo" {
  registry_id = data.aws_caller_identity.current.account_id
}

resource "aws_ecr_repository" "backend" {
  name                 = "backend"
  force_delete         = false
  image_tag_mutability = "IMMUTABLE"

  provisioner "local-exec" {
    command = "docker login --username AWS --password ${data.aws_ecr_authorization_token.repo.password} ${data.aws_ecr_authorization_token.repo.proxy_endpoint}"
  }

  provisioner "local-exec" {
    command = "docker build -t ce_micro_backend_tf ./src/backend/"
  }

  provisioner "local-exec" {
    command = "docker tag ce_micro_backend_tf ${self.repository_url}:latest"
  }

  provisioner "local-exec" {
    command = "docker push ${self.repository_url}:latest"
  }
}

resource "aws_ecr_repository" "frontend" {
  name                 = "frontend"
  force_delete         = false
  image_tag_mutability = "IMMUTABLE"

  provisioner "local-exec" {
    command = "docker login --username AWS --password ${data.aws_ecr_authorization_token.repo.password} ${data.aws_ecr_authorization_token.repo.proxy_endpoint}"
  }

  provisioner "local-exec" {
    command = "docker build -t ce_micro_frontend_tf ./src/frontend/"
  }

  provisioner "local-exec" {
    command = "docker tag ce_micro_frontend_tf ${self.repository_url}:latest"
  }

  provisioner "local-exec" {
    command = "docker push ${self.repository_url}:latest"
  }
}