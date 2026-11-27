mock_provider "azuread" {
  mock_resource "azuread_application" {
    defaults = {
      id        = "/applications/11111111-1111-1111-1111-111111111111"
      object_id = "11111111-1111-1111-1111-111111111111"
      client_id = "22222222-2222-2222-2222-222222222222"
    }
  }
}

variables {
  display_name = "app-test"
}

run "app_registration_only" {
  command = plan

  variables {
    create_service_principal = false
  }

  assert {
    condition     = length(azuread_service_principal.main) == 0
    error_message = "No enterprise application should be created when create_service_principal is false."
  }

  assert {
    condition     = length(azuread_application_password.main) == 0
    error_message = "No secret should be created when secret is null."
  }

  assert {
    condition     = length(azuread_application_federated_identity_credential.main) == 0
    error_message = "No federated credential should be created when federated_credentials is empty."
  }
}

run "enterprise_application_by_default" {
  command = plan

  assert {
    condition     = length(azuread_service_principal.main) == 1
    error_message = "An enterprise application should be created by default."
  }
}

run "with_secret" {
  command = apply

  variables {
    secret = {
      end_date = "2099-12-31T23:59:59Z"
    }
  }

  assert {
    condition     = length(azuread_application_password.main) == 1
    error_message = "A secret should be created when secret is set."
  }

  assert {
    condition     = azuread_application_password.main[0].end_date == "2099-12-31T23:59:59Z"
    error_message = "The secret end_date must match the requested expiration date."
  }

  assert {
    condition     = azuread_application_password.main[0].display_name == "terraform-managed"
    error_message = "The secret display_name should default to terraform-managed."
  }
}

run "with_federated_credentials" {
  command = plan

  variables {
    federated_credentials = {
      tfc-plan = {
        issuer  = "https://app.terraform.io"
        subject = "organization:org:project:proj:workspace:ws:run_phase:plan"
      }
      tfc-apply = {
        issuer  = "https://app.terraform.io"
        subject = "organization:org:project:proj:workspace:ws:run_phase:apply"
      }
    }
  }

  assert {
    condition     = length(azuread_application_federated_identity_credential.main) == 2
    error_message = "Two federated credentials should be created."
  }

  assert {
    condition     = azuread_application_federated_identity_credential.main["tfc-plan"].audiences == tolist(["api://AzureADTokenExchange"])
    error_message = "The default audience should be api://AzureADTokenExchange."
  }
}
