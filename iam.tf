locals {
  iam_role = [for iam in var.iam : iam if can(iam.role)]

  iam_roles = flatten([for iam in var.iam :
    [for role in iam.roles : merge(iam, { role = role })] if can(iam.roles)
  ])

  iam_map = { for iam in concat(local.iam_role, local.iam_roles) : iam.role => iam }

  iam = module.iam
}

module "iam" {
  source = "github.com/mineiros-io/terraform-google-project-iam?ref=v0.0.1"

  for_each = local.iam_map

  module_enabled    = var.module_enabled
  module_depends_on = [var.module_depends_on]

  project = google_project.project[0].project_id

  role = each.key

  members       = try(each.value.members, [])
  condition     = try(each.value.condition, null)
  authoritative = try(each.value.authoritative, true)
}
