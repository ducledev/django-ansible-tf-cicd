provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "django_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name    = "Django-Server-${var.project_name}"
    Project = var.project_name
  }

  vpc_security_group_ids = [aws_security_group.django_sg.id]
  subnet_id                   = aws_subnet.django_demo_public_subnet.id
  associate_public_ip_address = true
}

resource "aws_security_group" "django_sg" {
  name        = "django-sg-${var.project_name}"
  description = "Security group for Django server"
  vpc_id = aws_vpc.django_demo_vpc.id

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

// Updated VPC configuration
resource "aws_vpc" "django_demo_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "django-demo-vpc"
  }
}

resource "aws_internet_gateway" "django_demo" {
  vpc_id = aws_vpc.django_demo_vpc.id

  tags = {
    Name = "django-demo-igw"
  }
}

resource "aws_subnet" "django_demo_public_subnet" {
  vpc_id                  = aws_vpc.django_demo_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "django-demo-public-subnet"
  }
}

resource "aws_route_table" "django_demo_public_rt" {
  vpc_id = aws_vpc.django_demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.django_demo.id
  }

  tags = {
    Name = "django-demo-public-rt"
  }
}

resource "aws_route_table_association" "django_demo_public_rta" {
  subnet_id      = aws_subnet.django_demo_public_subnet.id
  route_table_id = aws_route_table.django_demo_public_rt.id
}
