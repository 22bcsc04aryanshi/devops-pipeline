variable "region" {
  default = "ap-south-1"
}

variable "github_token" {
  sensitive   = true
  description = "GitHub personal access token"
}

