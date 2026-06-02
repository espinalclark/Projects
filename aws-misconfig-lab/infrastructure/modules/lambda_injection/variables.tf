variable "lab_prefix" {
  description = "Prefijo para recursos"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "lambda_execution_role_arn" {
  description = "ARN del rol lambda-execution-role"
  type        = string
}
