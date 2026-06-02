output "webserver_public_ip" {
  value = aws_instance.webserver.public_ip
}

output "webserver_instance_id" {
  value = aws_instance.webserver.id
}

output "jumpbox_public_ip" {
  value = aws_instance.jumpbox.public_ip
}
