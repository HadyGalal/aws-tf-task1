output "bucket_name" {
  value       = aws_s3_bucket.site.bucket
  description = "S3 bucket name for the static site"
}

output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.cdn.id
  description = "CloudFront distribution ID"
}