resource "aws_s3_bucket" "ecommerce" {
  bucket = "ecommerce-raw-bart"
  acl    = "public-read"
  policy = "${file("policy.json")}"

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
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://s3-website-test.hashicorp.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

}
