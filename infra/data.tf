data "aws_caller_identity" "current" {}

data "external" "github_actions_variables" {
  program = ["bash", "-c", "echo \"name_repo=${NAME_REPO}\" >> ${GITHUB_ENV}"]
}