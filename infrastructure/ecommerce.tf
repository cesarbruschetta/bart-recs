resource "aws_s3_bucket" "ecommerce" {
  bucket = "ecommerce-raw-bart"
  acl    = "private"
  policy = "${file("ecommerce-policy.json")}"

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
