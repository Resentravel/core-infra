locals {
  # for_each cannot iterate a sensitive collection, but the names alone are not
  # secret. Only the values stay sensitive.
  repo_secret_pairs = merge([
    for repo, names in nonsensitive({ for r, s in var.repo_secrets : r => keys(s) }) : {
      for name in names : "${repo}/${name}" => { repo = repo, name = name }
    }
  ]...)

  repo_variable_pairs = merge([
    for repo, r in local.repositories : {
      for name, value in r.variables : "${repo}/${name}" => { repo = repo, name = name, value = value }
    }
  ]...)
}

# --- organization level ---------------------------------------------------

resource "github_actions_organization_secret" "this" {
  for_each = toset(nonsensitive(keys(var.org_secrets)))

  secret_name     = each.key
  plaintext_value = var.org_secrets[each.key]
  visibility      = "all"
}

resource "github_actions_organization_variable" "this" {
  for_each = local.org_variables

  variable_name = each.key
  value         = each.value
  visibility    = "all"
}

# --- repository level -----------------------------------------------------

resource "github_actions_secret" "this" {
  for_each = local.repo_secret_pairs

  repository      = github_repository.this[each.value.repo].name
  secret_name     = each.value.name
  plaintext_value = var.repo_secrets[each.value.repo][each.value.name]
}

resource "github_actions_variable" "this" {
  for_each = local.repo_variable_pairs

  repository    = github_repository.this[each.value.repo].name
  variable_name = each.value.name
  value         = each.value.value
}
