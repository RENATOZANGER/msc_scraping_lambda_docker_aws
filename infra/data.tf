data "aws_caller_identity" "current" {}

data "external" "github_actions_variables" {
  program = ["bash", "-c", "echo '{\"name_repo\":\"${process.env.NAME_REPO}\"}'"]
}