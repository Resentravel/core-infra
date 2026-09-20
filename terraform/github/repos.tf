# Adopt the repos that already exist instead of trying to create them.
# Safe to delete these blocks after the first successful apply.
import {
  for_each = local.repositories
  to       = github_repository.this[each.key]
  id       = each.key
}

resource "github_repository" "this" {
  for_each = local.repositories

  name         = each.key
  description  = each.value.description
  topics       = each.value.topics
  visibility   = "public"
  has_issues   = true
  has_projects = false
  has_wiki     = false

  delete_branch_on_merge = true
  archive_on_destroy     = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_branch_protection" "default" {
  for_each = local.branch_protection

  repository_id = github_repository.this[each.key].node_id
  pattern       = github_repository.this[each.key].default_branch

  required_pull_request_reviews {
    required_approving_review_count = each.value.required_approvals
    dismiss_stale_reviews           = true
  }
}

resource "github_team" "this" {
  for_each = local.teams

  name        = each.key
  description = each.value.description
  privacy     = "closed"
}

resource "github_team_membership" "this" {
  for_each = merge([
    for team, t in local.teams : {
      for user, role in t.members : "${team}/${user}" => { team = team, user = user, role = role }
    }
  ]...)

  team_id  = github_team.this[each.value.team].id
  username = each.value.user
  role     = each.value.role
}

resource "github_team_repository" "this" {
  for_each = merge([
    for team, t in local.teams : {
      for repo, perm in t.repos : "${team}/${repo}" => { team = team, repo = repo, permission = perm }
    }
  ]...)

  team_id    = github_team.this[each.value.team].id
  repository = github_repository.this[each.value.repo].name
  permission = each.value.permission
}
