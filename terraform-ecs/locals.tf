
locals {
  owners      = var.business-division
  Environment = var.environment
  Name        = "${var.environment}-${var.business-division}"

  common_tags = {
    owners      = local.owners
    environment = local.Environment
  }
  container_name_main  = "main-site"
  container_name_search = "search-site"
  container_name_owners = "owners-site"
  container_name_property = "property-site"
  container_name_ownerp = "ownerp-site"
}