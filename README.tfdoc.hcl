header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-project"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-project/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-project/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-project.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-project/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-project"
  toc     = true
  content = <<-END
    A [Terraform] module for creating and managing [projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects) in [Google Cloud Platform (GCP)][gcp].

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      A [Terraform] base module for creating a `google_project` resources. Which allows creation and management of a Google Cloud Platform project.
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage just setting required arguments:

      ```hcl
      module "terraform-google-project" {
        source = "github.com/mineiros-io/terraform-google-project.git?ref=v0.4.0"

        name       = "My Project"
        project_id = "your-project-id"
        org_id     = "1234567"
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Top-level Arguments"

      section {
        title = "Main Resource Configuration"

        variable "project_id" {
          required    = true
          type        = string
          description = <<-END
            The project ID. Changing this forces a new project to be created.
            **Note:** The project ID is a unique string used to differentiate your project from all others in Google Cloud.
          END
        }

        variable "name" {
          type        = string
          description = <<-END
            The display name of the project.
          END
          default     = var.project
        }

        variable "iam" {
          type           = list(iam)
          description    = <<-END
            A list of IAM access to apply to the created secret.
          END
          readme_example = <<-END
            iam = [
              {
                role    = "roles/viewer"
                members = ["user:member@example.com"]
              },
              {
                roles = [
                  "roles/editor",
                  "roles/owner",
                ]
                members = ["user:admin@example.com"]
              }
            ]
          END

          attribute "role" {
            type        = string
            description = <<-END
              The role that members will be assigned to.
              Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.
              At least one of `role` or `roles` needs to be set.
              Each role can only exist once within all elements of the list.
              Each role can only exist once within all elements of the list unless it specifies a different condition.
            END
          }

          attribute "roles" {
            type        = set(string)
            description = <<-END
              A set roles that members will be assigned to.
              Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.
              At least one of `role` or `roles` needs to be set.
              Each role can only exist once within all elements of the list unless it specifies a different condition.
            END
          }

          attribute "members" {
            type        = set(string)
            default     = []
            description = <<-END
              Identities that will be granted the privilege in role. Each entry can have one of the following values:
              - `allUsers`: A special identifier that represents anyone who is on the internet; with or without a Google account.
              - `allAuthenticatedUsers`: A special identifier that represents anyone who is authenticated with a Google account or a service account.
              - `user:{emailid}`: An email address that represents a specific Google account. For example, `alice@gmail.com` or `joe@example.com`.
              - `serviceAccount:{emailid}`: An email address that represents a service account. For example, `my-other-app@appspot.gserviceaccount.com`.
              - `group:{emailid}`: An email address that represents a Google group. For example, `admins@example.com`.
              - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, `google.com` or `example.com`.
              - `computed:{identifier}`: An existing key from `var.computed_members_map`.
            END
          }

          attribute "authoritative" {
            type        = bool
            default     = true
            description = <<-END
              Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.
            END
          }
        }

        variable "org_id" {
          type        = string
          description = <<-END
            The numeric ID of the organization this project belongs to. Changing this forces a new project to be created. Only one of `org_id` or `folder_id` may be specified. If the `org_id` is specified then the project is created at the top level. Changing this forces the project to be migrated to the newly specified organization.
          END
        }

        variable "folder_id" {
          type        = string
          description = <<-END
            The numeric ID of the folder this project should be created under. Only one of `org_id` or `folder_id` may be specified. If the `folder_id` is specified, then the project is created under the specified folder. Changing this forces the project to be migrated to the newly specified folder.
          END
        }

        variable "billing_account" {
          type        = string
          description = <<-END
            The alphanumeric ID of the billing account this project belongs to. The user or service account performing this operation with Terraform must have at minimum Billing Account User privileges (roles/billing.user) on the billing account.
          END
        }

        variable "skip_delete" {
          type        = bool
          default     = false
          description = <<-END
            If set to `true`, the Terraform resource can be deleted without deleting the Project via the Google API.
          END
        }

        variable "labels" {
          type        = map(string)
          default     = {}
          description = <<-END
            A set of key/value label pairs to assign to the project.
          END
        }

        variable "auto_create_network" {
          type        = bool
          default     = false
          description = <<-END
            Create the `default` network automatically.
            If kept as `false`, the default network will be deleted.
            Note that, for quota purposes, you will still need to have 1 network slot available to create the project successfully, even if you set `auto_create_network` to `false`, since the network will exist momentarily.

            It is recommended to use the `constraints/compute.skipDefaultNetworkCreation` constraint to remove the default network instead of setting `auto_create_network` to `false`.
          END
        }

        variable "computed_members_map" {
          type        = map(string)
          description = <<-END
             A map of members to replace in `members` of various IAM settings to handle terraform computed values.
           END
          default     = {}
        }
      }

      section {
        title = "Module Configuration"

        variable "module_enabled" {
          type        = bool
          default     = true
          description = <<-END
            Specifies whether resources in the module will be created.
          END
        }

        variable "module_depends_on" {
          type           = list(dependency)
          description    = <<-END
            A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.
          END
          readme_example = <<-END
            module_depends_on = [
              google_network.network
            ]
          END
        }
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "google_project" {
      type        = object(google_project)
      description = <<-END
        All outputs of the created `google_project` resource.
      END
    }

    output "iam" {
      type        = list(iam)
      description = <<-END
        The resources created by `mineiros-io/project-iam/google` module.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - Project: https://cloud.google.com/resource-manager/docs/creating-managing-projects
      END
    }

    section {
      title   = "Terraform Google Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-project"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-google-project/workflows/Tests/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-project.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-google-project/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-google-project/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "badge-tf-gcp" {
    value = "https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform"
  }
  ref "releases-google-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-google/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "gcp" {
    value = "https://cloud.google.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-project/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-project/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-project/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-project/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-project/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-project/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-project/blob/main/CONTRIBUTING.md"
  }
}
