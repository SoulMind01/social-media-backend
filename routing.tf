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
