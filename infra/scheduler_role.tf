resource "aws_iam_role" "scheduler_role" {
  name = var.role_scheduler_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = ["scheduler.amazonaws.com"]
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

data "aws_iam_policy_document" "scheduler_policy" {
  statement {
    actions = [
      "events:PutRule",
      "events:PutTargets"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_name}"
    ]
  }
}

resource "aws_iam_policy" "scheduler_access_policy" {
  name   = var.policy_scheduler_name
  policy = data.aws_iam_policy_document.scheduler_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_scheduler_policy" {
  role       = aws_iam_role.scheduler_role.name
  policy_arn = aws_iam_policy.scheduler_access_policy.arn
}
