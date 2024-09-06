variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  type        = string
  description = "django-ansible-tf-demo"
  default     = "django-ansible-tf-demo"
}