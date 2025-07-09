output "id" {
  description = "Specifies the resource ID of the Azure Container Registry."
  value       = azurerm_container_registry.acr.id
}

output "name" {
  description = "Specifies the name of the Azure Container Registry."
  value       = azurerm_container_registry.acr.name
}

output "hostname" {
  description = "Specifies the hostname of the Azure Container Registry."
  value       = azurerm_container_registry.acr.login_server
  sensitive   = true
}
