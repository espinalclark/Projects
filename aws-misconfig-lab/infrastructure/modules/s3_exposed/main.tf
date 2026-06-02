# SOLO PARA LABORATORIO CONTROLADO

# ── Bucket 1: backup público con credenciales ──────────────
resource "aws_s3_bucket" "backup" {
  bucket        = "${var.lab_prefix}-backup-2024"
  force_destroy = true
  tags = {
    Name = "${var.lab_prefix}-backup-2024"
    Lab  = "misconfig"
  }
}

resource "aws_s3_bucket_ownership_controls" "backup" {
  bucket = aws_s3_bucket.backup.id
  rule { object_ownership = "BucketOwnerPreferred" }
}

resource "aws_s3_bucket_public_access_block" "backup" {
  bucket                  = aws_s3_bucket.backup.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "backup" {
  depends_on = [
    aws_s3_bucket_ownership_controls.backup,
    aws_s3_bucket_public_access_block.backup,
  ]
  bucket = aws_s3_bucket.backup.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "backup" {
  depends_on = [aws_s3_bucket_public_access_block.backup]
  bucket     = aws_s3_bucket.backup.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicRead"
      Effect    = "Allow"
      Principal = "*"
      Action    = ["s3:GetObject"]
      Resource  = "${aws_s3_bucket.backup.arn}/*"
    }]
  })
}

resource "aws_s3_object" "credentials" {
  bucket       = aws_s3_bucket.backup.id
  key          = "configs/credentials.txt"
  content_type = "text/plain"
  content      = <<-EOT
    [dev-user]
    aws_access_key_id     = AKIAIOSFODNN7EXAMPLE
    aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    region = us-east-1
  EOT
}

# ── Bucket 2: docs internos público ───────────────────────
resource "aws_s3_bucket" "internal_docs" {
  bucket        = "${var.lab_prefix}-internal-docs"
  force_destroy = true
  tags = {
    Name = "${var.lab_prefix}-internal-docs"
    Lab  = "misconfig"
  }
}

resource "aws_s3_bucket_ownership_controls" "internal_docs" {
  bucket = aws_s3_bucket.internal_docs.id
  rule { object_ownership = "BucketOwnerPreferred" }
}

resource "aws_s3_bucket_public_access_block" "internal_docs" {
  bucket                  = aws_s3_bucket.internal_docs.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "internal_docs" {
  depends_on = [
    aws_s3_bucket_ownership_controls.internal_docs,
    aws_s3_bucket_public_access_block.internal_docs,
  ]
  bucket = aws_s3_bucket.internal_docs.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "internal_docs" {
  depends_on = [aws_s3_bucket_public_access_block.internal_docs]
  bucket     = aws_s3_bucket.internal_docs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicRead"
      Effect    = "Allow"
      Principal = "*"
      Action    = ["s3:GetObject"]
      Resource  = "${aws_s3_bucket.internal_docs.arn}/*"
    }]
  })
}

resource "aws_s3_object" "employees" {
  bucket       = aws_s3_bucket.internal_docs.id
  key          = "hr/employees.csv"
  content_type = "text/csv"
  content      = <<-EOT
    id,name,email,role,salary
    1,John Smith,jsmith@corp.com,DevOps Engineer,95000
    2,Maria Garcia,mgarcia@corp.com,Security Lead,110000
    3,Bob Johnson,bjohnson@corp.com,CTO,180000
  EOT
}

# ── Bucket 3: terraform state público ─────────────────────
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "${var.lab_prefix}-tf-state-lab"
  force_destroy = true
  tags = {
    Name = "${var.lab_prefix}-tf-state-lab"
    Lab  = "misconfig"
  }
}

resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule { object_ownership = "BucketOwnerPreferred" }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "terraform_state" {
  depends_on = [
    aws_s3_bucket_ownership_controls.terraform_state,
    aws_s3_bucket_public_access_block.terraform_state,
  ]
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "terraform_state" {
  depends_on = [aws_s3_bucket_public_access_block.terraform_state]
  bucket     = aws_s3_bucket.terraform_state.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicRead"
      Effect    = "Allow"
      Principal = "*"
      Action    = ["s3:GetObject"]
      Resource  = "${aws_s3_bucket.terraform_state.arn}/*"
    }]
  })
}

resource "aws_s3_object" "tfstate" {
  bucket       = aws_s3_bucket.terraform_state.id
  key          = "terraform.tfstate"
  content_type = "application/json"
  content = jsonencode({
    version           = 4
    terraform_version = "1.5.0"
    resources = [{
      type = "aws_db_instance"
      name = "corp_database"
      instances = [{
        attributes = {
          username = "admin"
          password = "Sup3rS3cr3t!"
          endpoint = "corp-database.us-east-1.rds.amazonaws.com"
        }
      }]
    }]
  })
}
