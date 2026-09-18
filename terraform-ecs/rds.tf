
# PostgreSQL RDS Instance
resource "aws_db_instance" "postgres" {
  identifier = var.db_identifier

  engine         = "postgres"
  engine_version = "16"

  instance_class = var.instance_class

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name = data.aws_ssm_parameter.db_name.value
  username = data.aws_ssm_parameter.db_user.value
  password = data.aws_ssm_parameter.db_password.value

  port = 5432

  vpc_security_group_ids = [
    aws_security_group.postgres_rds_sg.id
  ]

  db_subnet_group_name = module.vpc.database_subnet_group_name

  multi_az                = false
  publicly_accessible     = false
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  deletion_protection = false
  skip_final_snapshot = true
  //final_snapshot_identifier = "${var.db_identifier}-final-snapshot"

  tags = {
    Name        = "${local.Name}-postgres"
    Environment = var.environment
  }
}