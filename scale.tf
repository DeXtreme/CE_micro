resource "aws_launch_template" "tmpl" {
  name          = local.template_name
  description   = "Launch template for instances in the autoscaling group"
  image_id      = var.instance.ami
  instance_type = var.instance.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.instance.arn
  }

  vpc_security_group_ids = [aws_security_group.instance-sg.id]

  user_data = base64encode(<<EOF
    #!/bin/bash 
    echo ECS_CLUSTER=${local.cluster_name} >> /etc/ecs/ecs.config;
    EOF
  )
}

resource "aws_autoscaling_group" "auto" {
  name                = local.auto_scaling_group_name
  vpc_zone_identifier = [for subnet in module.vpc.public_subnets : subnet.id]
  max_size            = 1
  min_size            = 1
  desired_capacity    = 1

  launch_template {
    id = aws_launch_template.tmpl.id
  }
}

