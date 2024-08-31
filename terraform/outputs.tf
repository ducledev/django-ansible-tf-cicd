output "public_ip" {
  value = aws_instance.django_server.public_ip
}

output "key_name" {
  value = aws_key_pair.deployer.key_name
}