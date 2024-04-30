provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = var.bucket_name
    key = "lambda-scraping/terraform.tfstate"
    region = var.region
  }
}

resource "aws_lambda_function" "my_lambda" {
  function_name = var.lambda_name
  package_type  = "Image"
  image_uri     = "686148334870.dkr.ecr.us-east-1.amazonaws.com/lambda_scraping:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 90
}