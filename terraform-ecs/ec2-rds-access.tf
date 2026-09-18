resource "aws_instance" "postgres_client" {
  ami                    = data.aws_ami.my-data-ami.id
  instance_type          = var.instance-type-list[0]
  subnet_id              = module.vpc.public_subnets[0]
  key_name               = var.key-pair
  vpc_security_group_ids = [aws_security_group.postgres_client.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo amazon-linux-extras enable postgresql14
              sudo yum install postgresql -y
              EOF

  tags = {
    Name = "postgres-client"
  }
}