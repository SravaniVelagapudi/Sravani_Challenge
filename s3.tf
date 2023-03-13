# S3 bucket for static hosting
resource "aws_s3_bucket" "app-s3" {
  bucket = "s3-${var.project_name}-project"
}

resource "aws_s3_bucket_acl" "app-s3-acl" {
  bucket = aws_s3_bucket.app-s3.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app-s3-sse" {
  bucket = aws_s3_bucket.app-s3.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "app-s3-versioning" {
  bucket = aws_s3_bucket.app-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "app-s3-block" {
  bucket                  = aws_s3_bucket.app-s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


#Policy for s3 buckets
resource "aws_s3_bucket_policy" "app-s3-policy" {
  bucket = aws_s3_bucket.app-s3.id

  policy     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CloudfrontGetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_cloudfront_origin_access_identity.app-s3-origin-access-identity.iam_arn}"
      },
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.app-s3.arn}/*"
    },
    {
      "Sid": "AllowSSLRequestsOnly",
      "Action": "s3:*",
      "Effect": "Deny",
      "Resource": [
        "${aws_s3_bucket.app-s3.arn}",
        "${aws_s3_bucket.app-s3.arn}/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      },
      "Principal": "*"
    }
  ]
}
POLICY
  depends_on = [aws_s3_bucket_public_access_block.app-s3-block]
}

#Upload index-page.html to s3 bucket as index.html
resource "aws_s3_object" "app-s3-index" {
  bucket       = aws_s3_bucket.app-s3.id
  key          = "index.html"
  source       = "${path.module}/index-page.html"
  etag         = filemd5("${path.module}/index-page.html")
  content_type = "text/html"
}
