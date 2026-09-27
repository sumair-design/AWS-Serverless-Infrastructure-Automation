locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

data "archive_file" "start_lambda" {
  type        = "zip"
  source_file = "${path.module}/../lambda/start_instances.py"
  output_path = "${path.module}/start_instances.zip"
}

data "archive_file" "stop_lambda" {
  type        = "zip"
  source_file = "${path.module}/../lambda/stop_instances.py"
  output_path = "${path.module}/stop_instances.zip"
}

resource "aws_lambda_function" "start" {
  function_name    = "${local.name_prefix}-start"
  role             = aws_iam_role.lambda.arn
  runtime          = var.lambda_runtime
  handler          = "start_instances.lambda_handler"
  filename         = data.archive_file.start_lambda.output_path
  source_code_hash = data.archive_file.start_lambda.output_base64sha256
  timeout          = 60

  environment {
    variables = {
      TAG_KEY   = var.schedule_tag_key
      TAG_VALUE = var.schedule_tag_value
    }
  }
}

resource "aws_lambda_function" "stop" {
  function_name    = "${local.name_prefix}-stop"
  role             = aws_iam_role.lambda.arn
  runtime          = var.lambda_runtime
  handler          = "stop_instances.lambda_handler"
  filename         = data.archive_file.stop_lambda.output_path
  source_code_hash = data.archive_file.stop_lambda.output_base64sha256
  timeout          = 60

  environment {
    variables = {
      TAG_KEY   = var.schedule_tag_key
      TAG_VALUE = var.schedule_tag_value
    }
  }
}

resource "aws_cloudwatch_log_group" "start" {
  name              = "/aws/lambda/${aws_lambda_function.start.function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "stop" {
  name              = "/aws/lambda/${aws_lambda_function.stop.function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_event_rule" "start" {
  name                = "${local.name_prefix}-start-schedule"
  description         = "Start opted-in non-production EC2 instances."
  schedule_expression = var.start_schedule
}

resource "aws_cloudwatch_event_rule" "stop" {
  name                = "${local.name_prefix}-stop-schedule"
  description         = "Stop opted-in non-production EC2 instances."
  schedule_expression = var.stop_schedule
}

resource "aws_cloudwatch_event_target" "start" {
  rule      = aws_cloudwatch_event_rule.start.name
  target_id = "start-lambda"
  arn       = aws_lambda_function.start.arn
}

resource "aws_cloudwatch_event_target" "stop" {
  rule      = aws_cloudwatch_event_rule.stop.name
  target_id = "stop-lambda"
  arn       = aws_lambda_function.stop.arn
}

resource "aws_lambda_permission" "eventbridge_start" {
  statement_id  = "AllowEventBridgeStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start.arn
}

resource "aws_lambda_permission" "eventbridge_stop" {
  statement_id  = "AllowEventBridgeStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop.arn
}
