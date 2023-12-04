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

variable "project" {
  type        = string
  default     = null
  description = "Project ID"
}

variable "pool_id" {
  default     = "github"
  description = "ID of the Workload Identity Pool"
}

variable "pool_display_name" {
  default     = "GitHub"
  description = "Display name of the Workload Identity Pool"
}

variable "pool_provider_id" {
  default     = "github"
  description = "ID of the Workload Identity Pool Provider"
}

variable "pool_provider_display_name" {
  default     = "GitHub"
  description = "Display name of the Workload Identity Pool Provider"
}

variable "subject_mapping" {
  default     = "assertion.repository"
  description = "Mapping of GitHub JWT attributes to subject"
}

variable "attribute_mapping" {
  default     = {}
  type        = map(string)
  description = "Mapping of GitHub JWT attributes to additional attributes"
}

variable "attribute_condition" {
  default     = null
  type        = string
  description = "Condition for which credentials will be accepted"
}

variable "service_accounts" {
  default = {}
  type = map(object({
    subject              = string
    service_account_name = string
  }))
  description = "Access to service accounts based on subject"
}
