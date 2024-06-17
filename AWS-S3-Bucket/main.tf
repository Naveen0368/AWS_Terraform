provider "aws" {
  region = "us-east-1" # Specify your desired region
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-name" # Specify your desired bucket name
  acl    = "private" # Specify the ACL (Access Control List) for the bucket, such as "private", "public-read", etc.

  # Optionally, you can configure additional settings for the bucket:
  # For example, enabling versioning:
  versioning {
    enabled = true
  }

  # Or enabling server-side encryption:
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
