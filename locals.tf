locals {
  common_tags = {
    project = var.project
    environement = var.environment
  }

  az = slice(data.aws_availability_zones.available.names, 0, 2)
}