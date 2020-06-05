
resource "aws_api_gateway_rest_api" "bartRecommendationsAPI" {
  name = "api-bartRecommendations"
  description = "API para enviar as recomendações de produtos (bart-recs)"
 
  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }
}

resource "aws_api_gateway_authorizer" "bartRecommendationsAPIAuthorizer" {
  name                   = "authorizer-token"
  rest_api_id            = "${aws_api_gateway_rest_api.bartRecommendationsAPI.id}"
  authorizer_uri         = "${aws_lambda_function.bartRecommendationsLambdaAPIAuthorizer.invoke_arn}"
  authorizer_credentials = "${aws_iam_role.bartRecommendationsInvocationRole.arn}"

}

resource "aws_api_gateway_resource" "bartRecommendationsResource" {
  rest_api_id = "${aws_api_gateway_rest_api.bartRecommendationsAPI.id}"
  parent_id   = "${aws_api_gateway_rest_api.bartRecommendationsAPI.root_resource_id}"
  path_part   = "recommendations"

}

resource "aws_api_gateway_method" "bartRecommendationsMethod" {
  rest_api_id   = "${aws_api_gateway_rest_api.bartRecommendationsAPI.id}"
  resource_id   = "${aws_api_gateway_resource.bartRecommendationsResource.id}"
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = "${aws_api_gateway_authorizer.bartRecommendationsAPIAuthorizer.id}"  

}

resource "aws_api_gateway_integration" "bartRecommendationsIntegration" {
  rest_api_id          = "${aws_api_gateway_rest_api.bartRecommendationsAPI.id}"
  resource_id          = "${aws_api_gateway_resource.bartRecommendationsResource.id}"
  http_method          = "${aws_api_gateway_method.bartRecommendationsMethod.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.bartRecommendationsLambda.invoke_arn}"

}

resource "aws_api_gateway_deployment" "bartRecommendationsDeployment" {
  depends_on = [
    "aws_api_gateway_integration.bartRecommendationsIntegration",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.bartRecommendationsAPI.id}"
  stage_name  = "v1"

}