output "dev_user_access_key" {
  value     = aws_iam_access_key.dev_user.id
  sensitive = true
}

output "dev_user_secret_key" {
  value     = aws_iam_access_key.dev_user.secret
  sensitive = true
}

output "ci_deploy_access_key" {
  value     = aws_iam_access_key.ci_deploy.id
  sensitive = true
}

output "ci_deploy_secret_key" {
  value     = aws_iam_access_key.ci_deploy.secret
  sensitive = true
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_instance_role.name
}

output "lambda_execution_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}

output "cross_account_role_arn" {
  value = aws_iam_role.cross_account_role.arn
}
