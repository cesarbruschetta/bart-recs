resource "aws_s3_bucket" "lake-raw" {
  bucket = "prd-lake-raw-bart"
  acl    = "private"

  tags = {
    Name        = "DataLake Raw Bart-RECS"
    Environment = "PRD"
  }
}

resource "aws_s3_bucket" "lake-trusted" {
  bucket = "prd-lake-trusted-bart"
  acl    = "private"

  tags = {
    Name        = "DataLake Trusted Bart-RECS"
    Environment = "PRD"
  }
}