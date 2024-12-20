resource "aws_lambda_function" "app_function" {
  function_name = "AppFunction"
  runtime       = "nodejs16.x"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "function.zip"

  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }

  tags = {
    Name = "AppLambdaFunction"
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
