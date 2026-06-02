output "ssm_db_password_arn" {
  value = aws_ssm_parameter.db_password.arn
}

output "ssm_api_key_arn" {
  value = aws_ssm_parameter.api_key.arn
}

output "ssm_admin_secret_arn" {
  value = aws_ssm_parameter.admin_secret.arn
}

output "secrets_manager_arn" {
  value = aws_secretsmanager_secret.master_key.arn
}
