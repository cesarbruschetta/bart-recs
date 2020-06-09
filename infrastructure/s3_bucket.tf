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

resource "aws_s3_bucket_object" "BartRecsS3BucketSourcesRecommendationsLambda" {
  bucket = "${aws_s3_bucket.BartRecsS3BucketSources.bucket}"
  key    = "bart-recommendations-lambda.zip"
  source = "./sources/bart-recommendations-lambda.zip"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = "${filemd5("./sources/bart-recommendations-lambda.zip")}"
  
  tags = {
    Name        = "Sources to bart-recommendations Lambda"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}

resource "aws_s3_bucket_object" "BartRecsS3BucketSourcesExtractMainGlueJob" {
  bucket = "${aws_s3_bucket.BartRecsS3BucketSources.bucket}"
  key    = "glue/main.py"
  source = "./sources/bart-extract-data-ga/main.py"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = "${filemd5("./sources/bart-extract-data-ga/main.py")}"
  
  tags = {
    Name        = "Sources to Main.py bart-extract data GluJob"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}
resource "aws_s3_bucket_object" "BartRecsS3BucketSourcesExtractEggGlueJob" {
  bucket = "${aws_s3_bucket.BartRecsS3BucketSources.bucket}"
  key    = "library/bart_extract-0.1.0-py3-none-any.whl"
  source = "./sources/bart_extract-0.1.0-py3-none-any.whl"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = "${filemd5("./sources/bart_extract-0.1.0-py3-none-any.whl")}"
  
  tags = {
    Name        = "Sources to Egg bart-extract data GluJob"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}