provider "aws" {
  region = var.region
}

resource "aws_lambda_function" "my_lambda" {
  depends_on = [ aws_ecr_repository.this ]
  function_name = var.lambda_name
  package_type  = "Image"
  image_uri     = "686148334870.dkr.ecr.us-east-1.amazonaws.com/lambda_scraping:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 90
}