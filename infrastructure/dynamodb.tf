resource "aws_dynamodb_table" "bartRecommendationsWVAV" {
  name           = "bart-recommendations-wvav"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "source_item_id"

  attribute {
    name = "source_item_id"
    type = "S"
  }

  tags = {
    Name        = "bart-recommendations-wvav"
    Project     = "bart-recs"
    Environment = "PRD"
  }

}