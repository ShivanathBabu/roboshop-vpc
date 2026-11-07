variable cidr_block {
  type        = list(string)
  default     = ["10.0.0.0/16"]
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