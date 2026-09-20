# Terraform - GitHub org management

Manages the `Resentravel` GitHub organization: repositories, Actions
secrets and variables (org and repo level), teams, and branch protection.

## Layout (`github/`)

| File | Purpose |
| --- | --- |
| `locals.tf` | **Edit this.** Repos, org/repo variables, teams, branch protection |
| `secrets.auto.tfvars` | Secret values (gitignored, see `secrets.auto.tfvars.example`) |
| `repos.tf` | Repos (imported), branch protection, teams |
| `actions.tf` | Actions secrets and variables |

## Usage

```bash
cd terraform/github
cp secrets.auto.tfvars.example secrets.auto.tfvars   # then fill in values
terraform init
terraform plan  -var "github_token=ghp_..."   # PAT with repo, admin:org, workflow scopes
terraform apply -var "github_token=ghp_..."
```

Alternatively `export TF_VAR_github_token=ghp_...` (or `GITHUB_TOKEN`) once per
shell so you don't have to repeat `-var`.

The first plan imports the four existing repos (`core-api`, `core-front`,
`core-infra`, `core-docs`) and will show any drift from `locals.tf` (e.g.
descriptions, topics). Review it before applying.

## Notes

- **State holds secrets in plaintext.** Move to a private, encrypted remote
  backend (see the commented block in `main.tf`) before anyone else uses this.
- Secret values can't be read back from GitHub, so Terraform re-sets them from
  your tfvars. Removing a secret from the tfvars deletes it from GitHub.
- Repos have `prevent_destroy` and `archive_on_destroy` set as a safety net.
