resource "aws_s3_bucket" "BartRecsS3BucketLakeRaw" {
  bucket = "prd-lake-raw-bart"
  acl    = "private"

  tags = {
    Name        = "DataLake Raw Bart-RECS"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}

resource "aws_s3_bucket" "BartRecsS3BucketLakeTrusted" {
  bucket = "prd-lake-trusted-bart"
  acl    = "private"

  tags = {
    Name        = "DataLake Trusted Bart-RECS"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}

resource "aws_s3_bucket" "BartRecsS3BucketEcommerce" {
  bucket = "ecommerce-raw-bart"
  acl    = "private"
  policy = "${file("./sources/ecommerce-policy.json")}"

  tags = {
    Name        = "E-commerce Bart-RECS"
    Environment = "PRD"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

}

resource "aws_s3_bucket" "BartRecsS3BucketSources" {
  bucket = "source-bart-recs"
  acl    = "private"

  tags = {
    Name        = "Sources Bart-RECS"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}

resource "aws_s3_bucket_object" "BartRecsS3BucketSourcesBartSimulatorLambda" {
  bucket = "${aws_s3_bucket.BartRecsS3BucketSources.bucket}"
  key    = "bart-simulator-lambda.zip"
  source = "./sources/bart-simulator-lambda.zip"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = "${filemd5("./sources/bart-simulator-lambda.zip")}"
  
  tags = {
    Name        = "Sources to bart-simulator Lambda"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}