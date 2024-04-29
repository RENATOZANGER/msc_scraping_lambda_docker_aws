provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "my_lambda" {
  count         = length(data.aws_lambda_function.existing_lambda.function_name) > 0 ? 0 : 1
  function_name = "Scraping-MSC"
  package_type  = "Image"
  image_uri     = "686148334870.dkr.ecr.us-east-1.amazonaws.com/lambda_scraping:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 90 
}
