resource "aws_s3_bucket" "tf-bucket" {
    bucket = "tf-static-site-${random_id.suffix.hex}"
}

resource "aws_s3_bucket_ownership_controls" "bucket-cont" {
  bucket = aws_s3_bucket.tf-bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "pab" {
  bucket = aws_s3_bucket.tf-bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "task-file" {
  bucket = aws_s3_bucket.tf-bucket.id
  key = "task-1.html"
  source = "${path.module}/task-1.html"
  content_type = "text/html"

  depends_on = [ 
    aws_s3_bucket_policy.only_cloudfront,
    aws_s3_bucket_ownership_controls.bucket-cont,
    aws_s3_bucket_public_access_block.pab
   ]
}

//bucket policy
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "only_cloudfront" {
  bucket = aws_s3_bucket.tf-bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Sid = "AllowCloudFrontServicePrincipalReadOnly"
            Effect = "Allow"
            Principal = {
                Service = "cloudfront.amazonaws.com"
            }
            Action = ["s3:GetObject"]
            Resource = "${aws_s3_bucket.tf-bucket.arn}/*"
            Condition = {
                StringEquals = {
                    "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
                }
            }
        }
    ]
  })
}