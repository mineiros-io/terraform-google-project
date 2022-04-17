resource "google_project" "project" {
  count = var.module_enabled ? 1 : 0

  project_id = var.project_id
  name       = var.name != null ? var.name : var.project_id

  org_id    = var.org_id
  folder_id = var.folder_id

  billing_account     = var.billing_account
  skip_delete         = var.skip_delete
  labels              = var.labels
  auto_create_network = var.auto_create_network

  depends_on = [var.module_depends_on]
}
