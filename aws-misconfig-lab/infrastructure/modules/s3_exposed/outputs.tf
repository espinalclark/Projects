output "backup_bucket_name" {
  value = aws_s3_bucket.backup.id
}

output "internal_docs_bucket_name" {
  value = aws_s3_bucket.internal_docs.id
}

output "terraform_state_bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}
