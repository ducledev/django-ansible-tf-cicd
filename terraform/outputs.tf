output "public_ip" {
  value = length(aws_instance.django_server) > 0 ? aws_instance.django_server[0].public_ip : null
  description = "The public IP of the Django server (if created)"
}

output "key_name" {
  value = aws_key_pair.deployer.key_name
}