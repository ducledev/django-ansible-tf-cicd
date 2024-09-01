output "public_ip" {
  value = aws_instance.django_server.public_ip
  description = "The public IP of the Django server (if created)"
}

output "key_name" {
  value = aws_key_pair.deployer.key_name
  description = "The key name for the Django server"
}