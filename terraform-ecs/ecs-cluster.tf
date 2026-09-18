resource "aws_ecs_cluster" "lzb-project-main" {
  name = "wallawalla-cluster"
}

resource "aws_ecs_task_definition" "main" {
  family                   = "main-site"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "main-site"
      image = "${aws_ecr_repository.main.repository_url}:latest"

      environment = [
        {
          name  = "DB_HOST"
          value = aws_ssm_parameter.db_host.value
        },
        {
          name  = "DB_PORT"
          value = aws_ssm_parameter.db_port.value
        },
        {
          name  = "DB_NAME"
          value = aws_ssm_parameter.db_name.value
        },
        {
          name  = "DB_USER"
          value = aws_ssm_parameter.db_user.value
        },
        {
          name  = "S3_BUCKET_NAME"
          value = aws_ssm_parameter.s3_bucket_name.value
        },
        {
          name  = "SES_REGION"
          value = aws_ssm_parameter.ses_region.value
        },
        {
          name  = "COGNITO_USER_POOL_ID"
          value = aws_ssm_parameter.cognito_pool_id.value
        }
      ]
      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = aws_ssm_parameter.db_password.arn
        },
        {
          name      = "SECRET_KEY"
          valueFrom = aws_ssm_parameter.flask_secret.arn
        },
        {
          name      = "GOOGLE_MAPS_API_KEY"
          valueFrom = aws_ssm_parameter.google_maps_key.arn
        },
        {
          name      = "COGNITO_CLIENT_ID"
          valueFrom = aws_ssm_parameter.cognito_client_id.arn
        },

        {
          name  = "PAYFAST_MERCHANT_ID"
          value = aws_ssm_parameter.payfast-id.value
        },
        {
          name  = "PAYFAST_MERCHANT_KEY"
          value = aws_ssm_parameter.payfast-key.value
        },
        {
          name  = "PAYFAST_PASSPHRASE"
          value = aws_ssm_parameter.payfast-passphrase.value
        },
        {
          name  = "PAYFAST_SANDBOX"
          value = aws_ssm_parameter.payfast-sandbox.value
        }

      ]
      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/main-site"
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


resource "aws_ecs_task_definition" "owner" {
  family                   = "owner-site"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "owner-site"
      image = "${aws_ecr_repository.owner.repository_url}:latest"

      environment = [
        {
          name  = "DB_HOST"
          value = aws_ssm_parameter.db_host.value
        },
        {
          name  = "DB_PORT"
          value = aws_ssm_parameter.db_port.value
        },
        {
          name  = "DB_NAME"
          value = aws_ssm_parameter.db_name.value
        },
        {
          name  = "DB_USER"
          value = aws_ssm_parameter.db_user.value
        },
        {
          name  = "S3_BUCKET_NAME"
          value = aws_ssm_parameter.s3_bucket_name.value
        },
        {
          name  = "SES_REGION"
          value = aws_ssm_parameter.ses_region.value
        },
        {
          name  = "COGNITO_USER_POOL_ID"
          value = aws_ssm_parameter.cognito_pool_id.value
        },

        {
          name  = "PAYFAST_MERCHANT_ID"
          value = aws_ssm_parameter.payfast-id.value
        },
        {
          name  = "PAYFAST_MERCHANT_KEY"
          value = aws_ssm_parameter.payfast-key.value
        },
        {
          name  = "PAYFAST_PASSPHRASE"
          value = aws_ssm_parameter.payfast-passphrase.value
        },
        {
          name  = "PAYFAST_SANDBOX"
          value = aws_ssm_parameter.payfast-sandbox.value
        }
      ]
      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = aws_ssm_parameter.db_password.arn
        },
        {
          name      = "SECRET_KEY"
          valueFrom = aws_ssm_parameter.flask_secret.arn
        },
        {
          name      = "GOOGLE_MAPS_API_KEY"
          valueFrom = aws_ssm_parameter.google_maps_key.arn
        },
        {
          name      = "COGNITO_CLIENT_ID"
          valueFrom = aws_ssm_parameter.cognito_client_id.arn
        }
      ]

      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/owner-site"
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "lzb-project-main" {
  name            = "main-project-service"
  cluster         = aws_ecs_cluster.lzb-project-main.id
  task_definition = aws_ecs_task_definition.main.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = module.vpc.public_subnets[*]
    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main-tg.arn
    container_name   = local.container_name_main
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.main-listener]

}

resource "aws_ecs_service" "lzb-project-owner" {
  name            = "owner-project-service"
  cluster         = aws_ecs_cluster.lzb-project-main.id
  task_definition = aws_ecs_task_definition.owner.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = module.vpc.public_subnets[*]
    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.owner-tg.arn
    container_name   = local.container_name_owner
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.main-listener]

}


resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/main-site"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "owner" {
  name              = "/ecs/owner-site"
  retention_in_days = 14
}