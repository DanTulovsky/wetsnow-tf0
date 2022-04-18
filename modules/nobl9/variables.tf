variable "namespace" {
  type = string
}

variable "jira_api_token" {
  type      = string
  sensitive = true
}