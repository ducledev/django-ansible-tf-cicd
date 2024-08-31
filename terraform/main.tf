provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "django_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI (adjust as needed)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name  # Reference the key_name from aws_key_pair resource

  tags = {
    Name = "Django-Server"
  }

  vpc_security_group_ids = [aws_security_group.django_sg.id]
}

resource "aws_security_group" "django_sg" {
  name        = "django-sg"
  description = "Security group for Django server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.pk.private_key_pem
  filename = "${path.module}/deployer-key.pem"
}

output "public_ip" {
  value = aws_instance.django_server.public_ip
}