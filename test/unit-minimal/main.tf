module "test" {
  source = "../.."

  # add only required arguments and no optional arguments
  project_id = "unit-minimal-${local.random_suffix}"
}
