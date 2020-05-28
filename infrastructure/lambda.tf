resource "aws_lambda_permission" "bartRecommendationsAPILambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.bartRecommendationsLambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.bartRecommendationsAPI.execution_arn}/*/*/*"
}

resource "aws_lambda_function" "bartRecommendationsLambdaAPIAuthorizer" {
  function_name = "bart_recommendations_api_authorizer"
  filename      = "./sources/lambda-api-authorizer.zip"
  role          = "${aws_iam_role.bartRecommendationsLambdaRole.arn}"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.7"

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

  environment {
    variables = {
      AUTHORIZED_CLIENTS = "123456789,"
    }
  }
  
  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda-function.zip"))}"
  source_code_hash = "${filebase64sha256("./sources/lambda-api-authorizer.zip")}"
}

resource "aws_lambda_function" "bartRecommendationsLambda" {
  function_name = "bart-recommendations-api"
  role          = "${aws_iam_role.bartRecommendationsLambdaRole.arn}"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.7"

  depends_on = [
    "aws_iam_role_policy_attachment.bartRolePolicyAttachmentLambdaLogs"
  ]

  s3_bucket     = "${aws_s3_bucket.BartRecsS3BucketSources.bucket}"
  s3_key        = "bart-recommendations-lambda.zip"

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }
}

