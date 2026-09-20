output "repository_urls" {
  description = "URLs of the managed repositories"
  value       = { for name, r in github_repository.this : name => r.html_url }
}
