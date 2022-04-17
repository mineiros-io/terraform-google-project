// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT
// TERRAMATE: originated from generate_hcl block on /test/terramate.tm.hcl

variable "gcp_region" {
  default     = "europe-west3"
  description = "(Required) The gcp region in which all resources will be created."
  type        = string
}
variable "gcp_project" {
  description = "(Required) The ID of the project in which the resource belongs."
  type        = string
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}
provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}
