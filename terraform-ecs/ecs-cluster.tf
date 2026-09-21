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


resource "aws_ecs_task_definition" "search" {
  family                   = "search-site"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "search-site"
      image = "${aws_ecr_repository.search.repository_url}:latest"

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
          awslogs-group         = "/ecs/search-site"
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


resource "aws_ecs_task_definition" "owners" {
  family                   = "owners-site"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "owners-site"
      image = "${aws_ecr_repository.owners.repository_url}:latest"

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
          awslogs-group         = "/ecs/owners-site"
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


resource "aws_ecs_task_definition" "property" {
  family                   = "property-site"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "property-site"
      image = "${aws_ecr_repository.property.repository_url}:latest"

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
          awslogs-group         = "/ecs/property-site"
          awslogs-region        = "eu-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


resource "aws_ecs_task_definition" "ownerp" {
  family                   = "ownerp-site"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "ownerp-site"
      image = "${aws_ecr_repository.ownerp.repository_url}:latest"

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
          awslogs-group         = "/ecs/ownerp-site"
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

resource "aws_ecs_service" "lzb-project-search" {
  name            = "search-project-service"
  cluster         = aws_ecs_cluster.lzb-project-main.id
  task_definition = aws_ecs_task_definition.search.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = module.vpc.public_subnets[*]
    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.search-tg.arn
    container_name   = local.container_name_search
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.main-listener]

}

resource "aws_ecs_service" "lzb-project-owners" {
  name            = "owners-project-service"
  cluster         = aws_ecs_cluster.lzb-project-main.id
  task_definition = aws_ecs_task_definition.owners.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = module.vpc.public_subnets[*]
    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.owners-tg.arn
    container_name   = local.container_name_owners
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.main-listener]

}

resource "aws_ecs_service" "lzb-project-property" {
  name            = "property-project-service"
  cluster         = aws_ecs_cluster.lzb-project-main.id
  task_definition = aws_ecs_task_definition.property.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = module.vpc.public_subnets[*]
    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.property-tg.arn
    container_name   = local.container_name_property
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.main-listener]

}

resource "aws_ecs_service" "lzb-project-ownerp" {
  name            = "ownerp-project-service"
  cluster         = aws_ecs_cluster.lzb-project-main.id
  task_definition = aws_ecs_task_definition.ownerp.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = module.vpc.public_subnets[*]
    security_groups  = [aws_security_group.ecs-sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ownerp-tg.arn
    container_name   = local.container_name_ownerp
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.main-listener]

}


resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/main-site"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "search" {
  name              = "/ecs/search-site"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "owners" {
  name              = "/ecs/owners-site"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "property" {
  name              = "/ecs/property-site"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "ownerp" {
  name              = "/ecs/ownerp-site"
  retention_in_days = 14
}