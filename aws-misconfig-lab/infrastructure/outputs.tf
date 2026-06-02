output "vpc_id" {
  value = aws_vpc.lab.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "webserver_public_ip" {
  value = module.ec2_imdsv1.webserver_public_ip
}

output "jumpbox_public_ip" {
  value = module.ec2_imdsv1.jumpbox_public_ip
}
