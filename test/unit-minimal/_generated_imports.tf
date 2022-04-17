// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT
// TERRAMATE: originated from generate_hcl block on /test/terramate.tm.hcl

variable "gcp_org_domain" {
  description = "(Required) The domain of the organization test projects should be created in."
  type        = string
}
locals {
  domain        = var.gcp_org_domain
  org_id        = data.google_organization.org.name
  project_id    = data.google_project.project.project_id
  random_suffix = random_id.suffix.hex
}
data "google_project" "project" {
}
resource "random_id" "suffix" {
  byte_length = 16
}
data "google_organization" "org" {
  domain = local.domain
}
