variable "region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"
}

variable "lambda_name" {
  description = "lambda name"
  type        = string
  default     = "Scraping-MSC"
}

variable "policy_lambda_name" {
  description = "policy lambda name"
  type        = string
  default     = "policy_lambda_name"
}

variable "policy_scheduler_name" {
  description = "policy scheduler name"
  type        = string
  default     = "policy_scheduler_name"
}

variable "role_lambda_name" {
  description = "role lambda name"
  type        = string
  default     = "lambda_role"
}

variable "role_scheduler_name" {
  description = "role scheduler name"
  type        = string
  default     = "scheduler_role"
}

variable "bucket_name" {
  description = "bucket name"
  type        = string
  default     = "lambda-scraping-remote-state"
}

variable "repo_name" {
  description = "repo name"
  type        = string
  default     = "lambda_scraping"
}
