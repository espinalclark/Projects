variable "aws_region" {
  description = "Región AWS del lab"
  type        = string
  default     = "us-east-1"
}

variable "account_id" {
  description = "AWS Account ID del lab"
  type        = string
  default     = "351668480234"
}

variable "lab_prefix" {
  description = "Prefijo para todos los recursos"
  type        = string
  default     = "corp"
}
