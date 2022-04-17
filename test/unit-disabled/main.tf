module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments
  project_id = "unit-disabled-${local.random_suffix}"

  # add all optional arguments that create additional resources
  iam = [
    {
      role    = "roles/broswer"
      members = ["domain:${local.domain}"]
    }
  ]
}
