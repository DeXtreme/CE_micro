resource "aws_lb" "lb" {
  name     = "lb"
  internal = false

  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]

  subnets = [for subnet in module.vpc.public_subnets : subnet.id]
}

resource "aws_lb_target_group" "frontend" {
  name        = "frontend-group"
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "backend" {
  name        = "backend-group"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
  health_check {
    path = "/"
  }
}


resource "aws_lb_listener" "lb-fln" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}


resource "aws_lb_listener" "lb-bln" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

