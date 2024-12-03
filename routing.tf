resource "aws_api_gateway_rest_api" "app_api" {
  name = "App-API-Gateway"
}

resource "aws_api_gateway_resource" "root_resource" {
  rest_api_id = aws_api_gateway_rest_api.app_api.id
  parent_id   = aws_api_gateway_rest_api.app_api.root_resource_id
  path_part   = "app"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.app_api.id
  resource_id   = aws_api_gateway_resource.root_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_deployment" "app_deployment" {
  rest_api_id = aws_api_gateway_rest_api.app_api.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.method
  ]
}


resource "aws_api_gateway_stage" "app_stage" {
  stage_name    = "dev" # Match the stage name
  rest_api_id   = aws_api_gateway_rest_api.app_api.id
  deployment_id = aws_api_gateway_deployment.app_deployment.id
  description   = "Development stage"
  variables = {
    log_level = "INFO"
  }
}

# Associate the API Gateway to a lambda function
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.app_api.id
  resource_id             = aws_api_gateway_resource.root_resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST" # Required for AWS_PROXY
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_function.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.app_api.execution_arn}/*/*"
}

output "api_gateway_invoke_url" {
  value = aws_api_gateway_stage.app_stage.invoke_url
}
