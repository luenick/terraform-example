terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.13.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}


data "aws_canonical_user_id" "current" {}

#Create bucket named using environment variable
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

#Ensure best practice of bucket owner preferred
resource "aws_s3_bucket_ownership_controls" "own" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Set up public read access
resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = "${aws_s3_bucket.bucket.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
		"${aws_s3_bucket.bucket.arn}/*"
            ]
        }
    ]
}
EOF
}

# Create a test file inside the bucket
resource "aws_s3_object" "testfile" {
  bucket                 = aws_s3_bucket.bucket.id
  key                    = "test.txt"
  server_side_encryption = "AES256"
  content_type           = "text/plain"
  content                = <<EOF
Hello, World!
EOF
}

#Curl the file using the virtual-hosted-style URL, waiting for creation
resource "null_resource" "this" {
  depends_on = [aws_s3_object.testfile]
  provisioner "local-exec" {
    command = "curl https://${var.bucket_name}.s3.us-east-1.amazonaws.com/test.txt"
  }
}

