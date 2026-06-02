variable "lab_prefix" {
  description = "Prefijo para recursos"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID del lab"
  type        = string
}

variable "public_subnet_id" {
  description = "Subnet pública"
  type        = string
}

variable "private_subnet_id" {
  description = "Subnet privada"
  type        = string
}

variable "ec2_instance_profile_name" {
  description = "Instance profile del ec2-instance-role"
  type        = string
}
