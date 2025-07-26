variable "github_token" {
  type        = string
  description = "GitHub OAuth Token for CodePipeline"
  sensitive   = true
}

variable "region" {
  default = "ap-south-1"
}
