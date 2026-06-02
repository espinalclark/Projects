output "cloudtrail_name" {
  value = aws_cloudtrail.lab.name
}

output "cloudtrail_status" {
  value = "DISABLED - detection gap active"
}
