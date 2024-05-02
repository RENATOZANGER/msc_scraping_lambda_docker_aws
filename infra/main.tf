provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "lambda-scraping-remote-state"
    key    = "lambda-scraping/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_lambda_function" "my_lambda" {
  depends_on    = [aws_sns_topic_subscription.email_subscription]
  function_name = var.lambda_name
  package_type  = "Image"
  image_uri     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.repo_name}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 90
  memory_size   = 1024
  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.this.arn
      TARGET_VALUE  = "3.800"
      REGION        = var.region
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.my_lambda.function_name}"
  retention_in_days = 1
  depends_on        = [aws_lambda_function.my_lambda]
}