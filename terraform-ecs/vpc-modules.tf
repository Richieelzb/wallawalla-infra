module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"


  name = "${local.Name}-${var.vpc_name}"
  cidr = var.vpc_cidr_block

  azs              = var.vpc_availability_zones
  public_subnets   = var.vpc_public_subnets
  private_subnets  = var.vpc_private_subnets
  database_subnets = var.vpc_database_subnets

  create_database_subnet_group       = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  manage_default_network_acl         = false
  manage_default_route_table         = false
  manage_default_security_group      = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway

  database_subnet_tags = {
    Type = "database-subnets"
  }

  enable_dhcp_options     = true
  map_public_ip_on_launch = true

  tags = local.common_tags
}
