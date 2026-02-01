//necessary for cross-repo
resource "aws_ssm_parameter" "bucket_name" {
  name        = "/web/${local.env}/bucket_name"
  type        = "String"
  value       = aws_s3_bucket.site.bucket
  overwrite   = true
  description = "Static site bucket"
  tags        = local.tags
}

resource "aws_ssm_parameter" "distribution_id" {
  name        = "/web/${local.env}/distribution_id"
  type        = "String"
  value       = aws_cloudfront_distribution.cdn.id
  overwrite   = true
  description = "CloudFront distribution id"
  tags        = local.tags
}