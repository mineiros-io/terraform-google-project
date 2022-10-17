# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "project_id" {
  type        = string
  description = "(Required) The project ID. Changing this forces a new project to be created."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  type        = string
  description = "(Optional) The display name of the project. Defaults to project_id."
  default     = null
}

variable "iam" {
  type        = any
  description = "(Optional) List of IAM roles and members to set for the created project."
  default     = []
}

variable "org_id" {
  type        = string
  description = "(Optional) The numeric ID of the organization this project belongs to. Changing this forces a new project to be created. Only one of org_id or folder_id may be specified. If the org_id is specified then the project is created at the top level. Changing this forces the project to be migrated to the newly specified organization."
  default     = null
}

variable "folder_id" {
  type        = string
  description = "(Optional) The numeric ID of the folder this project should be created under. Only one of org_id or folder_id may be specified. If the folder_id is specified, then the project is created under the specified folder. Changing this forces the project to be migrated to the newly specified folder."
  default     = null
}

variable "billing_account" {
  type        = string
  description = "(Optional) The alphanumeric ID of the billing account this project belongs to. The user or service account performing this operation with Terraform must have at mininum Billing Account User privileges (roles/billing.user) on the billing account."
  default     = null
}

variable "skip_delete" {
  type        = bool
  description = "(Optional) If true, the Terraform resource can be deleted without deleting the Project via the Google API."
  default     = false
}

variable "labels" {
  type        = map(string)
  description = "(Optional) A set of key/value label pairs to assign to the project."
  default     = {}
}

variable "auto_create_network" {
  type        = bool
  description = <<-END
    (Optional)
    Create the 'default' network automatically.
    If kept false, the default network will be deleted.
    Note that, for quota purposes, you will still need to have 1 network slot available to create the project successfully, even if you set auto_create_network to false, since the network will exist momentarily.

    It is recommended to use the constraints/compute.skipDefaultNetworkCreation constraint to remove the default network instead of setting auto_create_network to false.
  END
  default     = false
}

variable "computed_members_map" {
  type        = map(string)
  description = "(Optional) A map of members to replace in 'members' to handle terraform computed values. Will be ignored when policy bindings are used."
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.computed_members_map : can(regex("^(user|serviceAccount|group|domain):", v))])
    error_message = "The value must be a non-empty string being a valid principal type prefixed with `user:`, `serviceAccount:`, `group:` or `domain:`."
  }
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# See https://medium.com/mineiros/the-ultimate-guide-on-how-to-write-terraform-modules-part-1-81f86d31f024
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on."
  default     = []
}
