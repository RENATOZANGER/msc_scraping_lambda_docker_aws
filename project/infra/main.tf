provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "Scraping-MSC"
  package_type = "Image"
  image_uri    = "686148334870.dkr.ecr.us-east-1.amazonaws.com/lambda_scraping"

  role = aws_iam_role.lambda_execution_role.arn
}
