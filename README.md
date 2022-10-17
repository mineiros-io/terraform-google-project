[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-project)

[![Build Status](https://github.com/mineiros-io/terraform-google-project/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-project/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-project.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-project/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-project

A [Terraform] module for creating and managing [projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects) in [Google Cloud Platform (GCP)][gcp].

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 4._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Google Documentation](#google-documentation)
  - [Terraform Google Provider Documentation](#terraform-google-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

A [Terraform] base module for creating a `google_project` resources. Which allows creation and management of a Google Cloud Platform project.

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-google-project" {
  source = "github.com/mineiros-io/terraform-google-project.git?ref=v0.2.0"

  name       = "My Project"
  project_id = "your-project-id"
  org_id     = "1234567"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Main Resource Configuration

- [**`project_id`**](#var-project_id): *(**Required** `string`)*<a name="var-project_id"></a>

  The project ID. Changing this forces a new project to be created.
  **Note:** The project ID is a unique string used to differentiate your project from all others in Google Cloud.

- [**`name`**](#var-name): *(Optional `string`)*<a name="var-name"></a>

  The display name of the project.

  Default is `var.project`.

- [**`iam`**](#var-iam): *(Optional `list(iam)`)*<a name="var-iam"></a>

  A list of IAM access to apply to the created secret.

  Example:

  ```hcl
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
  ```

  Each `iam` object in the list accepts the following attributes:

  - [**`role`**](#attr-iam-role): *(Optional `string`)*<a name="attr-iam-role"></a>

    The role that members will be assigned to.
    Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.
    At least one of `role` or `roles` needs to be set.
    Each role can only exist once within all elements of the list.
    Each role can only exist once within all elements of the list unless it specifies a different condition.

  - [**`roles`**](#attr-iam-roles): *(Optional `set(string)`)*<a name="attr-iam-roles"></a>

    A set roles that members will be assigned to.
    Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.
    At least one of `role` or `roles` needs to be set.
    Each role can only exist once within all elements of the list unless it specifies a different condition.

  - [**`members`**](#attr-iam-members): *(Optional `set(string)`)*<a name="attr-iam-members"></a>

    Identities that will be granted the privilege in role. Each entry can have one of the following values:
    - `allUsers`: A special identifier that represents anyone who is on the internet; with or without a Google account.
    - `allAuthenticatedUsers`: A special identifier that represents anyone who is authenticated with a Google account or a service account.
    - `user:{emailid}`: An email address that represents a specific Google account. For example, `alice@gmail.com` or `joe@example.com`.
    - `serviceAccount:{emailid}`: An email address that represents a service account. For example, `my-other-app@appspot.gserviceaccount.com`.
    - `group:{emailid}`: An email address that represents a Google group. For example, `admins@example.com`.
    - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, `google.com` or `example.com`.
    - `computed:{identifier}`: An existing key from `var.computed_members_map`.

    Default is `[]`.

  - [**`authoritative`**](#attr-iam-authoritative): *(Optional `bool`)*<a name="attr-iam-authoritative"></a>

    Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.

    Default is `true`.

- [**`org_id`**](#var-org_id): *(Optional `string`)*<a name="var-org_id"></a>

  The numeric ID of the organization this project belongs to. Changing this forces a new project to be created. Only one of `org_id` or `folder_id` may be specified. If the `org_id` is specified then the project is created at the top level. Changing this forces the project to be migrated to the newly specified organization.

- [**`folder_id`**](#var-folder_id): *(Optional `string`)*<a name="var-folder_id"></a>

  The numeric ID of the folder this project should be created under. Only one of `org_id` or `folder_id` may be specified. If the `folder_id` is specified, then the project is created under the specified folder. Changing this forces the project to be migrated to the newly specified folder.

- [**`billing_account`**](#var-billing_account): *(Optional `string`)*<a name="var-billing_account"></a>

  The alphanumeric ID of the billing account this project belongs to. The user or service account performing this operation with Terraform must have at minimum Billing Account User privileges (roles/billing.user) on the billing account.

- [**`skip_delete`**](#var-skip_delete): *(Optional `bool`)*<a name="var-skip_delete"></a>

  If set to `true`, the Terraform resource can be deleted without deleting the Project via the Google API.

  Default is `false`.

- [**`labels`**](#var-labels): *(Optional `map(string)`)*<a name="var-labels"></a>

  A set of key/value label pairs to assign to the project.

  Default is `{}`.

- [**`auto_create_network`**](#var-auto_create_network): *(Optional `bool`)*<a name="var-auto_create_network"></a>

  Create the `default` network automatically.
  If kept as `false`, the default network will be deleted.
  Note that, for quota purposes, you will still need to have 1 network slot available to create the project successfully, even if you set `auto_create_network` to `false`, since the network will exist momentarily.

  It is recommended to use the `constraints/compute.skipDefaultNetworkCreation` constraint to remove the default network instead of setting `auto_create_network` to `false`.

  Default is `false`.

- [**`computed_members_map`**](#var-computed_members_map): *(Optional `map(string)`)*<a name="var-computed_members_map"></a>

  A map of members to replace in `members` of various IAM settings to handle terraform computed values.

  Default is `{}`.

#### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:

  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`google_project`**](#output-google_project): *(`object(google_project)`)*<a name="output-google_project"></a>

  All outputs of the created `google_project` resource.

- [**`iam`**](#output-iam): *(`list(iam)`)*<a name="output-iam"></a>

  The resources created by `mineiros-io/project-iam/google` module.

## External Documentation

### Google Documentation

- Project: https://cloud.google.com/resource-manager/docs/creating-managing-projects

### Terraform Google Provider Documentation

- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-project
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-google-project/workflows/Tests/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-google-project.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[build-status]: https://github.com/mineiros-io/terraform-google-project/actions
[releases-github]: https://github.com/mineiros-io/terraform-google-project/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[terraform]: https://www.terraform.io
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-project/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-project/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-project/issues
[license]: https://github.com/mineiros-io/terraform-google-project/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-project/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-project/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-project/blob/main/CONTRIBUTING.md
