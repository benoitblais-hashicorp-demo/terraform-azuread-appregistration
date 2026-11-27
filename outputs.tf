output "application_id" {
  description = "The resource ID of the app registration (/applications/{object_id})."
  value       = azuread_application.main.id
}

output "application_object_id" {
  description = "The object ID of the app registration."
  value       = azuread_application.main.object_id
}

output "client_id" {
  description = "The client ID (application ID) of the app registration."
  value       = azuread_application.main.client_id
}

output "client_secret" {
  description = "The generated client secret value. Null when no secret is requested."
  value       = one(azuread_application_password.main[*].value)
  sensitive   = true
}

output "client_secret_end_date" {
  description = "The expiration date of the generated client secret. Null when no secret is requested."
  value       = one(azuread_application_password.main[*].end_date)
}

output "display_name" {
  description = "The display name of the app registration."
  value       = azuread_application.main.display_name
}

output "federated_credential_ids" {
  description = "Map of federated identity credential IDs, keyed by the credential display name."
  value       = { for name, credential in azuread_application_federated_identity_credential.main : name => credential.credential_id }
}

output "flexible_federated_credential_ids" {
  description = "Map of flexible federated identity credential IDs, keyed by the credential display name."
  value       = { for name, credential in azuread_application_flexible_federated_identity_credential.main : name => credential.credential_id }
}

output "service_principal_object_id" {
  description = "The object ID of the enterprise application (service principal). Null when create_service_principal is false."
  value       = one(azuread_service_principal.main[*].object_id)
}
