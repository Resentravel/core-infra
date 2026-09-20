terraform {
  # `import` blocks with for_each need 1.7+
  required_version = ">= 1.7"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  # State contains secret values in plaintext. Local state is fine to start
  # (it is gitignored) but move to a private remote backend before sharing, e.g.:
  #
  # backend "s3" {
  #   bucket       = "resentravel-tfstate"
  #   key          = "github/terraform.tfstate"
  #   region       = "eu-central-1"
  #   encrypt      = true
  #   use_lockfile = true
  # }
}

# Token comes from -var "github_token=..." (or TF_VAR_github_token). When null,
# the provider falls back to the GITHUB_TOKEN environment variable.
provider "github" {
  owner = var.github_owner
  token = var.github_token
}
