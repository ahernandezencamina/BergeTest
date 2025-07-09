output "id" {
  description = "Specifies the ID of the Azure Container App Environment."
  value       = azurerm_container_app_environment.ace.id
}

output "default_domain" {
  description = "Specifies the default, publicly resolvable, name of this Container App Environment."
  value       = azurerm_container_app_environment.ace.default_domain
}

