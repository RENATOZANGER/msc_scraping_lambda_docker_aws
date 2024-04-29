variable "criate_bucket" {
  description = "flag to control bucket"
  type        = bool
  default     = true
}

variable "region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"
}
