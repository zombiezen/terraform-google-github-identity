# Copyright 2023 Ross Light
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "registry.terraform.io/hashicorp/google"
      version = ">= 4.0, < 6.0"
    }
  }
}

resource "google_project_service" "cloudresourcemanager" {
  project            = var.project
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam" {
  project            = var.project
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "iam_credentials" {
  project            = var.project
  service            = "iamcredentials.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "security_token_service" {
  project            = var.project
  service            = "sts.googleapis.com"
  disable_on_destroy = false
}

resource "google_iam_workload_identity_pool" "main" {
  project                   = var.project
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name

  depends_on = [
    google_project_service.cloudresourcemanager,
    google_project_service.iam,
    google_project_service.iam_credentials,
    google_project_service.security_token_service,
  ]
}

resource "google_iam_workload_identity_pool_provider" "main" {
  project                            = var.project
  workload_identity_pool_id          = google_iam_workload_identity_pool.main.workload_identity_pool_id
  workload_identity_pool_provider_id = var.pool_provider_id
  display_name                       = var.pool_provider_display_name

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com/"
  }

  attribute_mapping = merge(var.attribute_mapping, {
    "google.subject" = var.subject_mapping
  })

  attribute_condition = var.attribute_condition
}

resource "google_service_account_iam_member" "impersonation" {
  for_each           = var.service_accounts
  service_account_id = each.value.service_account_name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.main.name}/${each.value.subject}"
}
