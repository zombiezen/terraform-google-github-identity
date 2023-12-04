# Terraform for GitHub Actions Workload Identity Federation

This is a Terraform module to set up
[keyless authentication from GitHub Actions](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions).

## Example

```terraform
terraform {
  required_version = "~> 1.0"
}

provider "google" {
  project = "PROJECTID"
}

module "github_identity_pool" {
  source  = "zombiezen/github-identity/google"
  version = "0.1.2"

  attribute_condition = "assertion.repository=='octocat/example'"

  service_accounts = {
    main = {
      subject              = "octocat/example"
      service_account_name = google_service_account.github_actions.name
    }
  }
}

resource "google_service_account" "github_actions" {
  account_id   = "github"
  display_name = "GitHub Actions"
}
```

## License

[Apache 2.0](LICENSE)

