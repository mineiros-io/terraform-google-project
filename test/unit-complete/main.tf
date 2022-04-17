module "test" {
  source = "../.."

  # add all required arguments
  project_id = "unit-complete-${local.random_suffix}"

  iam = [
    {
      role    = "roles/broswer"
      members = ["domain:${local.domain}"]
    },
    {
      role    = "roles/broswer"
      members = ["domain:${local.domain}"]
      condition = {
        title       = "deny after 2025"
        description = "allow access until 2025"
        expression  = "request.time.getFullYear() < 2025"
      }
    },
    {
      role    = "roles/broswer"
      members = ["domain:${local.domain}"]
      condition = {
        title       = "allow after 2020"
        description = "allow access from 2020"
        expression  = "request.time.getFullYear() > 2020"
      }
    }
  ]
}
