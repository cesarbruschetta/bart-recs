
resource "aws_cloudwatch_event_rule" "bartSimulatorCloudwatchEveryRule" {
  name                = "bart-simulato-send-pageviewed"
  description         = "Envia os dado ao GA 3x ao dia"
  schedule_expression = "rate(8 hours)"
  
  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }
}

resource "aws_cloudwatch_event_target" "artSimulatorCloudwatchEveryTarget" {
  rule      = "${aws_cloudwatch_event_rule.bartSimulatorCloudwatchEveryRule.name}"
  target_id = "bart-simulato-lambda"
  arn       = "${aws_lambda_function.bartSimulatorLambda.arn}"

}