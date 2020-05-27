
resource "aws_cloudwatch_event_rule" "bartSimulatorCloudwatchEveryRule" {
  name                = "bart-simulator-send-pageviewed"
  description         = "Envia os dado ao GA 3x ao dia"
  schedule_expression = "rate(8 hours)"
  
  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }
}
