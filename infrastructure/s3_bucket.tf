locals {
  bart_datasets = reverse(fileset("./sources/", "*.whl"))[0]
  bart_datasets_version =  sort(regex("([0-9.]{5})", local.bart_datasets))[0]
}

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

  etag = "${filemd5("./sources/bart-recommendations-lambda.zip")}"
  
  tags = {
    Name        = "Sources to bart-recommendations Lambda"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}

resource "aws_s3_bucket_object" "BartRecsS3BucketSourcesExtractEggGlueJob" {

  bucket = "${aws_s3_bucket.BartRecsS3BucketSources.bucket}"
  key    = "library/bart_datasets-${local.bart_datasets_version}-py3-none-any.whl"
  source = "./sources/bart_datasets-${local.bart_datasets_version}-py3-none-any.whl"

  etag = "${filemd5("./sources/bart_datasets-${local.bart_datasets_version}-py3-none-any.whl")}"
  
  tags = {
    Name        = "Sources to whl bart-extract data GluJob"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}

resource "aws_s3_bucket_object" "BartRecsS3BucketSourcesGACredentials" {
  bucket = "${aws_s3_bucket.BartRecsS3BucketSources.bucket}"
  key    = "credentials/GA_credentials.json"
  source = "${var.ga_credential}"

  etag = "${filemd5("${var.ga_credential}")}"

  tags = {
    Name        = "GA Credentials to bart-extract data GlueJob"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}

resource "aws_s3_bucket_object" "BartRecsS3BucketSourcesExtractMainGlueJob" {
  bucket = "${aws_s3_bucket.BartRecsS3BucketSources.bucket}"
  key    = "glue/bart-extract-data-ga.py"
  source = "./sources/aws-glue/bart-extract-data-ga.py"

  etag = "${filemd5("./sources/aws-glue/bart-extract-data-ga.py")}"
  
  tags = {
    Name        = "Sources to bart-extract data in GlueJob"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}

resource "aws_s3_bucket_object" "BartRecsS3BucketSourcesJoinDataMainGlueJob" {
  bucket = "${aws_s3_bucket.BartRecsS3BucketSources.bucket}"
  key    = "glue/bart-join-data-ga.py"
  source = "./sources/aws-glue/bart-join-data-ga.py"

  etag = "${filemd5("./sources/aws-glue/bart-join-data-ga.py")}"
  
  tags = {
    Name        = "Sources to bart-join-data in GlueJob"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}

resource "aws_s3_bucket_object" "BartRecsS3BucketSourcesCalcPublishMainGlueJob" {
  bucket = "${aws_s3_bucket.BartRecsS3BucketSources.bucket}"
  key    = "glue/bart-calc-publish-recs.py"
  source = "./sources/aws-glue/bart-calc-publish-recs.py"

  etag = "${filemd5("./sources/aws-glue/bart-calc-publish-recs.py")}"
  
  tags = {
    Name        = "Sources to bart-calc-publish-recs in GlueJob"
    Environment = "PRD"
    Project     = "bart-recs"
  }
}
