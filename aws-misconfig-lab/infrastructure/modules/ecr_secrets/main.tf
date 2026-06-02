# Vector: ECR imagen con secrets hardcodeados en layers

resource "aws_ecr_repository" "corp_app" {
  name                 = "${var.lab_prefix}-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  # Scan deshabilitado - no detecta secrets
  image_scanning_configuration {
    scan_on_push = false
  }

  tags = { Lab = "misconfig" }
}

resource "aws_ecr_repository_policy" "corp_app" {
  repository = aws_ecr_repository.corp_app.name

  # Cualquier cuenta AWS puede hacer pull
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PublicPull"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}

# ── Dockerfile con secrets embebidos ──────────────────────
resource "local_file" "dockerfile" {
  filename = "/tmp/lab-docker/Dockerfile"
  content  = <<-EOF
    FROM python:3.11-slim

    WORKDIR /app

    # Secrets hardcodeados en la imagen
    RUN echo "[default]\naws_access_key_id = AKIAIOSFODNN7EXAMPLE\naws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" > /root/.aws/credentials

    COPY .env /app/.env

    RUN pip install flask

    CMD ["python", "-c", "print('corp-app running')"]
  EOF
}

resource "local_file" "env_file" {
  filename = "/tmp/lab-docker/app/.env"
  content  = <<-EOF
    DB_HOST=corp-database.us-east-1.rds.amazonaws.com
    DB_USER=admin
    DB_PASSWORD=Sup3rS3cr3t!
    API_KEY=sk-prod-xxxxxxxxxxxxxxxxxxxx
    SECRET_KEY=my-super-secret-flask-key
  EOF
}
