resource "aws_iam_role" "bartLambdaRole" {
  name = "bart-lamnda-role"
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

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "bartPolicyLambdaLogging" {
  name        = "bart-lambda-logging"
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

resource "aws_iam_role_policy_attachment" "bartRolePolicyAttachmentLambdaLogs" {
  role       = "${aws_iam_role.bartLambdaRole.name}"
  policy_arn = "${aws_iam_policy.bartPolicyLambdaLogging.arn}"

}