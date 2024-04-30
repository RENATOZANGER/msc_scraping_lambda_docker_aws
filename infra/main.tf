provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "lambda-scraping-remote-state"
    key = "lambda-scraping/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_lambda_function" "my_lambda" {
  function_name = var.lambda_name
  package_type  = "Image"
  image_uri     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${data.external.github_actions_variables.result["name_repo"]}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 90
}