output "ecr_repository_url" {
  value = aws_ecr_repository.corp_app.repository_url
}

output "ecr_repository_name" {
  value = aws_ecr_repository.corp_app.name
}
