
locals {
  owners      = var.business-division
  Environment = var.environment
  Name        = "${var.environment}-${var.business-division}"

  common_tags = {
    owners      = local.owners
    environment = local.Environment
  }
  container_name_main  = "main-site"
  container_name_owner = "owner-site"
}