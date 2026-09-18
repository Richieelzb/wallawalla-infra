data "aws_availability_zones" "my-zones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ami" "my-data-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "db_name" {
  name = "/wallawalla/prod/db-name"
}

data "aws_ssm_parameter" "db_user" {
  name = "/wallawalla/prod/db-user"
}

data "aws_ssm_parameter" "db_password" {
  name            = "/wallawalla/prod/db-password"
  with_decryption = true
}