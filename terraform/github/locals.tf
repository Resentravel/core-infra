# Edit this file to change what is managed in the org. Secret *values* are not
# kept here - they come in through var.org_secrets / var.repo_secrets.
locals {
  # Organization-level Actions variables (visible to every repo).
  org_variables = {
    # ORG_NAME = "Resentravel"
  }

  repositories = {
    core-api = {
      description = "Core API"
      topics      = ["api"]
      variables   = {}
    }
    core-front = {
      description = "Core frontend"
      topics      = ["frontend"]
      variables   = {}
    }
    core-infra = {
      description = "Infrastructure as code for Resentravel"
      topics      = ["infrastructure", "terraform"]
      variables   = {}
    }
    core-docs = {
      description = "Documentation"
      topics      = ["docs"]
      variables   = {}
    }
  }

  # Teams: members map username => "member" | "maintainer";
  # repos map repo_name => pull | triage | push | maintain | admin.
  teams = {
    # devs = {
    #   description = "Developers"
    #   members     = { some-user = "member" }
    #   repos       = { core-api = "push", core-front = "push" }
    # }
  }

  # Branch protection on the default branch, per repo. Left off so you can keep
  # pushing to main directly; uncomment to require PRs.
  branch_protection = {
    # core-api = { required_approvals = 1 }
  }
}
