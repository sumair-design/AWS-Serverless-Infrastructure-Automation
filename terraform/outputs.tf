output "start_lambda_name" {
  value = aws_lambda_function.start.function_name
}

output "stop_lambda_name" {
  value = aws_lambda_function.stop.function_name
}

output "start_schedule_rule" {
  value = aws_cloudwatch_event_rule.start.name
}

output "stop_schedule_rule" {
  value = aws_cloudwatch_event_rule.stop.name
}
