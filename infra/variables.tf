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

variable "policy_name" {
  description = "policy name"
  type        = string
  default     = "ECRAccessPolicy"
}

variable "role_name" {
  description = "role name"
  type        = string
  default     = "lambda_role"
}

variable "bucket_name" {
  description = "bucket name"
  type        = string
  default     = "lambda-scraping-remote-state"
}

variable "Name_Repo" {}