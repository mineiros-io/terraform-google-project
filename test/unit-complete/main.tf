module "test-sa" {
  source = "github.com/mineiros-io/terraform-google-service-account?ref=v0.0.12"

  account_id = "service-account-id-${local.random_suffix}"
}

module "test" {
  source = "../.."

  # add all required arguments
  project_id          = "unit-complete-${local.random_suffix}"
  name                = "unit-complete"
  billing_account     = local.billing_account
  folder_id           = "1234567"
  skip_delete         = true
  auto_create_network = true

  labels = {
    foo = "bar"
  }

  iam = [
    {
      role    = "roles/broswer"
      members = ["domain:${local.org_domain}"]
    },
    {
      role    = "roles/broswer"
      members = ["domain:${local.org_domain}"]
      condition = {
        title       = "deny after 2025"
        description = "allow access until 2025"
        expression  = "request.time.getFullYear() < 2025"
      }
    },
    {
      role    = "roles/broswer"
      members = ["domain:${local.org_domain}"]
      condition = {
        title       = "allow after 2020"
        description = "allow access from 2020"
        expression  = "request.time.getFullYear() > 2020"
      }
      authoritative = false
    },
    {
      members = ["computed:${module.test-sa.service_account.email}"]
    }
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }
}

module "test1" {
  source = "../.."

  # add all required arguments
  project_id          = "unit-complete-${local.random_suffix}"
  name                = "unit-complete"
  billing_account     = local.billing_account
  org_id              = local.org_id
  skip_delete         = true
  auto_create_network = true

  labels = {
    foo = "bar"
  }

  iam = [
    {
      role    = "roles/broswer"
      members = ["domain:${local.org_domain}"]
    },
    {
      role    = "roles/broswer"
      members = ["domain:${local.org_domain}"]
      condition = {
        title       = "deny after 2025"
        description = "allow access until 2025"
        expression  = "request.time.getFullYear() < 2025"
      }
    },
    {
      role    = "roles/broswer"
      members = ["domain:${local.org_domain}"]
      condition = {
        title       = "allow after 2020"
        description = "allow access from 2020"
        expression  = "request.time.getFullYear() > 2020"
      }
      authoritative = false
    },
    {
      members = ["computed:${module.test-sa.service_account.email}"]
    }
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }
}
