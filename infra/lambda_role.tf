resource "aws_iam_role" "lambda_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    actions   = [
      "ecr:GetAuthorizationToken",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ] 
    resources = ["*"]
  }

  statement {
    actions   = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/${var.repo_name}"
    ]
  }

  statement {
    actions   = [
      "sns:Publish"
    ]
    resources = [
      "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:send-email-msc"
    ]
  }

    statement {
    actions   = [
      "lambda:InvokeFunction"
    ]
    resources = [
      "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_name}"
    ]
  }
}


resource "aws_iam_policy" "ecr_access_policy" {
  name   = var.policy_name
  policy = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_ecr_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}
