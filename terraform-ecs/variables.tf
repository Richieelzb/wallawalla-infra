//Resources///////////////////////////////////////////////////////

variable "instance-type-list" {
  type    = list(string)
  default = ["t3.micro", "t3.small", "t3.large"]
}

variable "zone_id" {
  description = "Route 53 Hosted Zone ID for DNS validation"
  type        = string
  default     = "Z084454530ALJ4JVWZ65K" // wallawalla.co.za
}

///VPC Modules ///////////////////////////////////////////////////////////////////////////
variable "vpc_name" {
  type    = string
  default = "wallawalla-vpc"
}

variable "vpc_availability_zones" {
  type    = list(string)
  default = []
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_public_subnets" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "vpc_private_subnets" {
  type    = list(string)
  default = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "vpc_database_subnets" {
  type    = list(string)
  default = ["10.0.30.0/24", "10.0.31.0/24"]
}

variable "vpc_create_database_subnet_group" {
  type    = bool
  default = false
}

variable "vpc_create_database_subnet_route_table" {
  type    = bool
  default = false
}

variable "vpc_enable_nat_gateway" {
  type    = bool
  default = false
}

variable "vpc_single_nat_gateway" {
  type    = bool
  default = false
}

variable "key-pair" {
  default = "wallawalla-key"
}


//////generic/////////////////////////////
variable "aws-region" {
  default = "eu-west-1"
}

variable "environment" {
  type    = string
  default = "Dev"
}

variable "business-division" {
  type    = string
  default = "wallawalla"
}


//////////////////RDS/////////////////////////////


variable "allowed_cidrs" {
  type = list(string)
}

variable "db_identifier" {
  type = string
}

variable "instance_class" {
  type = string
}