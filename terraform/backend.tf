terraform {
  backend "s3" {
    bucket         = "django-demo-terraform-state"
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "django-demo-terraform-state-lock"
    encrypt        = true
  }
}
