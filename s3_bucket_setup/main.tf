provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "django-demo-terraform-state"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "django-demo-terraform-state-lock"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

// New S3 bucket resource
resource "aws_s3_bucket" "key_bucket" {
  bucket = var.keys_bucket_name

  tags = {
    Name    = var.keys_bucket_name
    Project = var.project_name
  }
}

// New S3 bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "key_bucket_ownership" {
  bucket = aws_s3_bucket.key_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

// New S3 bucket ACL
resource "aws_s3_bucket_acl" "key_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.key_bucket_ownership]

  bucket = aws_s3_bucket.key_bucket.id
  acl    = "private"
}
