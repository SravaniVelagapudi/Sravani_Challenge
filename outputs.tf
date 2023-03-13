output "app_domain_name" {
  value = aws_cloudfront_distribution.app-cf.domain_name
}

output "app_s3_arn" {
  value = aws_s3_bucket.app-s3.arn
}
