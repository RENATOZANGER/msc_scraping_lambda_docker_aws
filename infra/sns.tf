resource "aws_sns_topic" "this" {
  name = "send-email-msc"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = "renato.zanger@gmail.com"
}