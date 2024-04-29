data "aws_lambda_function" "this" {
  function_name = var.lambda_name
}

data "aws_iam_policy" "this" {
  name = "ECRAccessPolicy" 
}