# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "google_project" {
  description = "The outputs of the created Google service accounts."
  value       = try(google_project.project[0], null)
}

output "iam" {
  description = "The resources created by `mineiros-io/project-iam/google` module."
  value       = module.iam
}
