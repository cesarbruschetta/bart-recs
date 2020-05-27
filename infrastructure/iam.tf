resource "aws_iam_role" "bartRecommendationsLambdaRole" {
  name = "bart-recommendations-lambda-role"
  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role" "bartRecommendationsInvocationRole" {
  name = "bart-recommendations-api-auth-invocation"
  path = "/"

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "bartRecommendationsPolicyLambdaLogging" {
  name        = "bart-recommendations-lambda-logging"
  path        = "/"
  description = "(Bart-Recs) IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "bartRecommendationsInvocationPolicy" {
  name = "bartRecommendations-invocation-default"
  role = "${aws_iam_role.bartRecommendationsInvocationRole.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${aws_lambda_function.bartRecommendationsLambdaAPIAuthorizer.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "bartRolePolicyAttachmentLambdaLogs" {
  role       = "${aws_iam_role.bartRecommendationsLambdaRole.name}"
  policy_arn = "${aws_iam_policy.bartRecommendationsPolicyLambdaLogging.arn}"
}
