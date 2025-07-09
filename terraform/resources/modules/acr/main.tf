resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  tags                = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_role_assignment" "service_principals_role_assignment_acr_pull" {
  for_each = { for i, val in var.identity_service_principal_ids : i => val }

  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "acrpull"
  principal_id                     = each.value
  skip_service_principal_aad_check = true
  principal_type                   = "ServicePrincipal"
}

resource "azurerm_role_assignment" "service_principals_role_assignment_acr_push" {
  for_each = { for i, val in var.identity_service_principal_ids : i => val }

  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "acrpush"
  principal_id                     = each.value
  skip_service_principal_aad_check = true
  principal_type                   = "ServicePrincipal"
}
