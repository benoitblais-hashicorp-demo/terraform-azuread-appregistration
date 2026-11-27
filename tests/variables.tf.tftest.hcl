mock_provider "azuread" {}

variables {
  display_name = "app-test"
}

run "invalid_display_name" {
  command = plan

  variables {
    display_name = " "
  }

  expect_failures = [
    var.display_name,
  ]
}

run "invalid_sign_in_audience" {
  command = plan

  variables {
    sign_in_audience = "Everyone"
  }

  expect_failures = [
    var.sign_in_audience,
  ]
}

run "invalid_owners" {
  command = plan

  variables {
    owners = ["not-a-guid"]
  }

  expect_failures = [
    var.owners,
  ]
}

run "invalid_secret_end_date" {
  command = plan

  variables {
    secret = {
      end_date = "31/12/2099"
    }
  }

  expect_failures = [
    var.secret,
  ]
}

run "invalid_secret_display_name" {
  command = plan

  variables {
    secret = {
      end_date     = "2099-12-31T23:59:59Z"
      display_name = " "
    }
  }

  expect_failures = [
    var.secret,
  ]
}

run "invalid_federated_credential_issuer" {
  command = plan

  variables {
    federated_credentials = {
      bad = {
        issuer  = "http://app.terraform.io"
        subject = "organization:org:project:proj:workspace:ws:run_phase:plan"
      }
    }
  }

  expect_failures = [
    var.federated_credentials,
  ]
}

run "invalid_federated_credential_subject" {
  command = plan

  variables {
    federated_credentials = {
      bad = {
        issuer  = "https://app.terraform.io"
        subject = ""
      }
    }
  }

  expect_failures = [
    var.federated_credentials,
  ]
}

run "invalid_federated_credential_audiences" {
  command = plan

  variables {
    federated_credentials = {
      bad = {
        issuer    = "https://app.terraform.io"
        subject   = "organization:org:project:proj:workspace:ws:run_phase:plan"
        audiences = []
      }
    }
  }

  expect_failures = [
    var.federated_credentials,
  ]
}

run "invalid_flexible_federated_credential_issuer" {
  command = plan

  variables {
    flexible_federated_credentials = {
      bad = {
        issuer                     = "http://app.terraform.io"
        claims_matching_expression = "claims['sub'] matches 'organization:org:project:proj:workspace:*:run_phase:*'"
      }
    }
  }

  expect_failures = [
    var.flexible_federated_credentials,
  ]
}

run "invalid_flexible_federated_credential_expression" {
  command = plan

  variables {
    flexible_federated_credentials = {
      bad = {
        issuer                     = "https://app.terraform.io"
        claims_matching_expression = "organization:org:project:proj:workspace:*"
      }
    }
  }

  expect_failures = [
    var.flexible_federated_credentials,
  ]
}

run "invalid_flexible_federated_credential_audience" {
  command = plan

  variables {
    flexible_federated_credentials = {
      bad = {
        issuer                     = "https://app.terraform.io"
        claims_matching_expression = "claims['sub'] matches 'organization:org:project:proj:workspace:*:run_phase:*'"
        audience                   = " "
      }
    }
  }

  expect_failures = [
    var.flexible_federated_credentials,
  ]
}