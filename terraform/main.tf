provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "django_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name  # Reference the key_name from aws_key_pair resource

  tags = {
    Name = "Django-Server"
  }

  vpc_security_group_ids = [aws_security_group.django_sg.id]
}

resource "random_id" "sg_suffix" {
  byte_length = 4
}

resource "aws_security_group" "django_sg" {
  name        = "django-sg-${random_id.sg_suffix.hex}"
  description = "Security group for Django server"

  lifecycle {
    create_before_destroy = true
  }

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

resource "random_id" "key_suffix" {
  byte_length = 4
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-${random_id.key_suffix.hex}"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.pk.private_key_pem
  filename = "${path.module}/deployer-key-${random_id.key_suffix.hex}.pem"
}
