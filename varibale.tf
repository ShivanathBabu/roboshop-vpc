variable cidr_block {
  default     = "10.0.0.0/16"
}

variable "project" {
  
}

variable "environment" {
  
}

variable "public_subnet" {
  type = list(string)
}

variable "private_subnet" {
  type = list(string)
}

variable "database_subnet" {
  type = list(string)
}