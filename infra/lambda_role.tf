resource "aws_iam_role" "lambda_role" {
  name = var.role_lambda_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = ["lambda.amazonaws.com"]
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
    ]
    resources = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_name}:*"]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/${var.repo_name}"
    ]
  }

  statement {
    actions = [
      "sns:Publish"
    ]
    resources = [
      "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:send-email-msc"
    ]
  }
}

resource "aws_iam_policy" "lambda_access_policy" {
  name   = var.policy_lambda_name
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_access_policy.arn
}
