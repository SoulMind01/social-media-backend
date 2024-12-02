# CloudWatch Log Group for Lambda Function Logs
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/app-function"
  retention_in_days = 30

  tags = {
    Name = "LambdaLogGroup"
  }
}

# CloudWatch Metric Alarms for Lambda Function Errors
resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "LambdaErrorAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    FunctionName = aws_lambda_function.app_function.function_name
  }

  alarm_description = "Alarm if Lambda function reports errors."
  alarm_actions     = [] # Add SNS or Auto-Scaling Policy ARN if needed

  tags = {
    Name = "LambdaErrorAlarm"
  }
}

# CloudWatch Metric Alarms for DynamoDB Read/Write Capacity
resource "aws_cloudwatch_metric_alarm" "dynamodb_read_alarm" {
  alarm_name          = "DynamoDBReadCapacityAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsumedReadCapacityUnits"
  namespace           = "AWS/DynamoDB"
  period              = 300
  statistic           = "Sum"
  threshold           = 80

  dimensions = {
    TableName = aws_dynamodb_table.app_table.name
  }

  alarm_description = "Alarm if DynamoDB Read Capacity exceeds 80%."
  alarm_actions     = [] # Add SNS ARN if needed

  tags = {
    Name = "DynamoDBReadCapacityAlarm"
  }
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_write_alarm" {
  alarm_name          = "DynamoDBWriteCapacityAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsumedWriteCapacityUnits"
  namespace           = "AWS/DynamoDB"
  period              = 300
  statistic           = "Sum"
  threshold           = 80

  dimensions = {
    TableName = aws_dynamodb_table.app_table.name
  }

  alarm_description = "Alarm if DynamoDB Write Capacity exceeds 80%."
  alarm_actions     = [] # Add SNS ARN if needed

  tags = {
    Name = "DynamoDBWriteCapacityAlarm"
  }
}

# CloudWatch Dashboard for Visualizing Metrics
resource "aws_cloudwatch_dashboard" "app_dashboard" {
  dashboard_name = "AppMonitoringDashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 6,
        height = 6,
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.app_function.function_name],
            ["AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", aws_dynamodb_table.app_table.name],
            ["AWS/DynamoDB", "ConsumedWriteCapacityUnits", "TableName", aws_dynamodb_table.app_table.name],
          ],
          view    = "timeSeries",
          stacked = false,
          region  = "us-west-1",
          title   = "App Metrics"
        }
      }
    ]
  })
}
