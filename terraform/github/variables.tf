variable "github_owner" {
  description = "GitHub organization to manage"
  type        = string
  default     = "Resentravel"
}

variable "github_token" {
  description = "GitHub token (classic PAT with repo, admin:org, workflow scopes). Pass with -var on the command line."
  type        = string
  sensitive   = true
  default     = null
}

variable "org_secrets" {
  description = "Organization-level Actions secrets: { SECRET_NAME = value }. Supply via secrets.auto.tfvars (gitignored) or TF_VAR_org_secrets."
  type        = map(string)
  sensitive   = true
  default     = {}
}

variable "repo_secrets" {
  description = "Repository-level Actions secrets: { repo_name = { SECRET_NAME = value } }. Supply via secrets.auto.tfvars (gitignored) or TF_VAR_repo_secrets."
  type        = map(map(string))
  sensitive   = true
  default     = {}
}
