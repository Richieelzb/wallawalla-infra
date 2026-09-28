resource "aws_launch_template" "ecs" {
  name_prefix   = "wallawalla-ecs-"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = "t3.large"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs.name
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=wallawalla-cluster >> /etc/ecs/ecs.config
EOF
  )

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ecs-sg.id]
  }
}


resource "aws_autoscaling_group" "ecs" {
  desired_capacity = 1
  min_size         = 1
  max_size         = 2

  vpc_zone_identifier = module.vpc.public_subnets

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "wallawalla-ecs-node"
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "wallawalla" {
  name = "wallawalla-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs.arn

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 2
    }

    managed_termination_protection = "DISABLED"
  }
}

resource "aws_ecs_cluster_capacity_providers" "wallawalla" {
  cluster_name = aws_ecs_cluster.lzb-project-main.name

  capacity_providers = [
    aws_ecs_capacity_provider.wallawalla.name
  ]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.wallawalla.name
    weight            = 1
  }
}