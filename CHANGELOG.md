# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0]

### Added

 - Add support for `var.computed_members_map`

### Removed

 - BREAKING CHANGE: Remove support for Terraform before v1.0
 - BREAKING CHANGE: Remove support for Terraform Google Provider before v4.0

## [0.3.0] includes BREAKING CHANGES

- Add support for multiple roles with different permissions.
  This might recreate resources if conditions were used.
- Remove `module_enabled` output.

## [0.2.1]

### Added

- Add information to the README that the `project_id` needs to be unique from all others in GCP

### Changed

- Upgrade Makefile from template
- Upgrade pre-commit hooks to `v0.3.2`

## [0.2.0]

### Added

- Support for provider 4.x
- Add support default service accounts in `roles/editor` bindings

### Changed

- upgrade mineiros-io/project-iam/google to v0.1.0

## [0.1.0]

### Added

- IAM Support

## [0.0.1]

### Added

- Initial Implementation

[unreleased]: https://github.com/mineiros-io/terraform-google-project/compare/v0.4.0...HEAD
[0.3.0]: https://github.com/mineiros-io/terraform-google-project/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/mineiros-io/terraform-google-project/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/mineiros-io/terraform-google-project/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/mineiros-io/terraform-google-project/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/mineiros-io/terraform-google-project/compare/v0.0.1...v0.1.0
[0.0.1]: https://github.com/mineiros-io/terraform-google-project/releases/tag/v0.0.1
