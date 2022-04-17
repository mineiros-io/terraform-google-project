locals {
  # filter all objects that define a single role
  iam_role = [for iam in var.iam : iam if can(iam.role)]

  # filter all objects that define multiple roles and expand them to single roles
  iam_roles = flatten([for iam in var.iam :
    [for role in iam.roles : merge(iam, { role = role })] if can(iam.roles)
  ])

  iam = concat(local.iam_role, local.iam_roles)

  iam_map = { for iam in local.iam :
    try("${iam.role}/${iam.condition._key}", "${iam.role}/${md5(jsonencode(iam.condition))}", iam.role) => iam
  }
}

module "iam" {
  source = "github.com/mineiros-io/terraform-google-project-iam?ref=v0.1.1"

  for_each = local.iam_map

  module_enabled    = var.module_enabled
  module_depends_on = [var.module_depends_on]

  project = try(google_project.project[0].project_id, null)

  role = each.value.role

  members       = try(each.value.members, [])
  condition     = try(each.value.condition, null)
  authoritative = try(each.value.authoritative, true)
}
