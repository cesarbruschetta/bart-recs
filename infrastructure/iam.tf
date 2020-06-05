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

resource "aws_iam_role" "bartSimulatorTaskExecutionRole" {
  name = "bartSimulator-task-execution-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role" "bartExtractGlueJobRole" {
  name = "bartExtract-AWSGlue-JobRoleDefault"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "bartRecommendationsPolicyLogging" {
  name        = "bart-recommendations-logging"
  path        = "/"
  description = "(Bart-Recs) IAM policy for logging"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
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

resource "aws_iam_role_policy" "bartExtractGlueS3Policy" {
  name = "bartExtract-glue-s3-policy"
  role = "${aws_iam_role.bartExtractGlueJobRole.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::*",
        "arn:aws:s3:::*/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "bartRolePolicyAttachmentLambdaLogs" {
  role       = "${aws_iam_role.bartRecommendationsLambdaRole.name}"
  policy_arn = "${aws_iam_policy.bartRecommendationsPolicyLogging.arn}"
}

# Attach the above policy to the execution role.
resource "aws_iam_role_policy_attachment" "bartSimulatorTaskExecutionAttachment" {
  role = "${aws_iam_role.bartSimulatorTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "bartSimulatorTaskExecutionAttachmentLog" {
  role = "${aws_iam_role.bartSimulatorTaskExecutionRole.name}"
  policy_arn = "${aws_iam_policy.bartRecommendationsPolicyLogging.arn}"
}

resource "aws_iam_role_policy_attachment" "bartExtractGlueJobAttachment" {
    role = "${aws_iam_role.bartExtractGlueJobRole.id}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
