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