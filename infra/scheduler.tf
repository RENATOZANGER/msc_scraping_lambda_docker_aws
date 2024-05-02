resource "aws_scheduler_schedule" "scheduler_lambda" {
  name                         = "scheduler-Lambda-MSC"
  group_name                   = "default"
  schedule_expression_timezone = "America/Sao_Paulo"
  state                        = "ENABLED"
  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "rate(30 minutes)"

  target {
    arn      = aws_lambda_function.my_lambda.arn
    role_arn = aws_iam_role.scheduler_role.arn
  }
}
