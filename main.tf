provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./vpc"

  name           = "vpc"
  cidr           = var.vpc_cidr
  public_subnets = var.public_subnets
}


resource "aws_ecs_capacity_provider" "provider" {
  name = "provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.auto.arn
    managed_termination_protection = "DISABLED"
    managed_scaling {
      status          = "ENABLED"
      target_capacity = 100
    }
  }

}

resource "aws_ecs_cluster" "cluster" {
  name = local.cluster_name
}

resource "aws_ecs_cluster_capacity_providers" "providers" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = [aws_ecs_capacity_provider.provider.name]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = aws_ecs_capacity_provider.provider.name
  }
}


resource "aws_ecs_task_definition" "services" {
  family       = "services"
  network_mode = "awsvpc"
  memory       = 512
  cpu          = 256

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      name  = "backend"
      image = "${aws_ecr_repository.backend.repository_url}:latest"
      portMappings = [{
        containerPort = 5000
        protocol      = "tcp",
        appProtocol   = "http"
      }],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/backend"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
        secretOptions = []
      }
    },
    {
      name  = "frontend"
      image = "${aws_ecr_repository.frontend.repository_url}:latest"
      environment = [{
        name  = "backend"
        value = aws_lb.lb.dns_name
      }]
      portMappings = [{
        containerPort = 4000
        protocol      = "tcp",
        appProtocol   = "http"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/frontend"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
        secretOptions = []
      }
    }
  ])
}

resource "aws_ecs_service" "micro" {
  name            = "micro"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.services.arn
  desired_count   = 1
  network_configuration {
    subnets         = [for subnet in module.vpc.public_subnets : subnet.id]
    security_groups = [aws_security_group.micro-sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = 4000
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 5000
  }
}