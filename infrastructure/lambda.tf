
resource "aws_lambda_permission" "bartSimulatorCloudwatchLambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.bartSimulatorLambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.bartSimulatorCloudwatchEveryRule.arn}"

}

resource "aws_lambda_function" "bartSimulatorLambda" {
  function_name = "bart-simulator-pageviewed"
  role          = "${aws_iam_role.bartLambdaRole.arn}"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.7"
  
  depends_on = [
    "aws_iam_role_policy_attachment.bartRolePolicyAttachmentLambdaLogs"
  ]

  s3_bucket     = "${aws_s3_bucket.BartRecsS3BucketSources.bucket}"
  s3_key        = "bart-simulator-lambda.zip"

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

}
