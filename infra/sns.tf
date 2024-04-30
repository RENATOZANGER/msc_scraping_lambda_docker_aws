# Criando um tópico SNS
resource "aws_sns_topic" "my_topic" {
  name = "send-email-msc"
}

# Criando uma inscrição via e-mail no tópico SNS
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "email"
  endpoint  = "renato.zanger@gmail.com"
}