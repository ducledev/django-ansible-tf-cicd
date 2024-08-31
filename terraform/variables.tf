variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "ap-southeast-1"
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  default     = "ami-0f74c08b8b5effa56"  # Amazon Linux 2 AMI for ap-southeast-1
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance"
  default     = "your-key-pair-name"
}