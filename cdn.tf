
resource "aws_cloudfront_origin_access_identity" "app-s3-origin-access-identity" {
  comment = "Origin access identify Used for CDN S3 Buckets"
}

resource "aws_cloudfront_distribution" "app-cf" {
  default_root_object = "index.html"
  comment             = "${var.project_name} cdn"
  enabled             = true
  is_ipv6_enabled     = true

  origin {
    domain_name = aws_s3_bucket.app-s3.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.app-s3.id
    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.app-s3-origin-access-identity.id}"
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    target_origin_id = aws_s3_bucket.app-s3.id
    max_ttl          = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
