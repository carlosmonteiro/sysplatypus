resource "aws_s3_bucket" "websiteBucket" {
  bucket = var.bucketname

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "websiteBucket" {
  bucket = aws_s3_bucket.websiteBucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "websiteBucket" {
  bucket = aws_s3_bucket.websiteBucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "websiteACL" {
  depends_on = [
        aws_s3_bucket_ownership_controls.websiteBucket,
        aws_s3_bucket_public_access_block.websiteBucket
    ]

  bucket = aws_s3_bucket.websiteBucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.websiteBucket.id
  key    = "index.html"
  source = "../website/index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.websiteBucket.id
  key    = "error.html"
  source = "../website/error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "styles" {
  bucket = aws_s3_bucket.websiteBucket.id
  key    = "styles.css"
  source = "../website/styles.css"
  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.websiteBucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.websiteACL]
}