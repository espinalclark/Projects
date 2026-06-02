# Vector: SSM Parameter Store + Secrets Manager exposure

# ── SSM Parameter Store ────────────────────────────────────
resource "aws_ssm_parameter" "db_password" {
  name        = "/corp/db/password"
  description = "Database password - lab only"
  type        = "SecureString"
  value       = "Sup3rS3cr3t!"

  tags = { Lab = "misconfig" }
}

resource "aws_ssm_parameter" "api_key" {
  name        = "/corp/api/key"
  description = "API key - lab only"
  type        = "SecureString"
  value       = "sk-prod-xxxxxxxxxxxxxxxxxxxx"

  tags = { Lab = "misconfig" }
}

resource "aws_ssm_parameter" "admin_secret" {
  name        = "/corp/admin/secret"
  description = "Admin secret - lab only"
  type        = "SecureString"
  value       = "adm1n-sup3r-s3cr3t-2024!"

  tags = { Lab = "misconfig" }
}

# ── Secrets Manager ────────────────────────────────────────
resource "aws_secretsmanager_secret" "master_key" {
  name                    = "prod/corp/master-key"
  description             = "Master key - lab only"
  recovery_window_in_days = 0

  tags = { Lab = "misconfig" }
}

resource "aws_secretsmanager_secret_version" "master_key" {
  secret_id = aws_secretsmanager_secret.master_key.id
  secret_string = jsonencode({
    username   = "corp-admin"
    password   = "M4st3rK3y-2024!"
    db_host    = "corp-database.us-east-1.rds.amazonaws.com"
    admin_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.fake"
  })
}
