generate_hcl "_generated_provider.tf" {
  content {
    variable "gcp_region" {
      type        = string
      description = "(Required) The gcp region in which all resources will be created."
      default     = "europe-west3"
    }

    variable "gcp_project" {
      type        = string
      description = "(Required) The ID of the project in which the resource belongs."
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
      region  = var.gcp_region
      project = var.gcp_project
    }
  }
}

generate_hcl "_generated_imports.tf" {
  content {
    variable "gcp_org_domain" {
      type        = string
      description = "(Required) The domain of the organization test projects should be created in."
    }

    locals {
      project_id    = data.google_project.project.project_id
      random_suffix = random_id.suffix.hex
      org_id        = data.google_organization.org.name
      domain        = var.gcp_org_domain
    }

    data "google_project" "project" {}

    resource "random_id" "suffix" {
      byte_length = 16
    }


    data "google_organization" "org" {
      domain = local.domain
    }
  }
}
