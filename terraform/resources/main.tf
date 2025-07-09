data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

resource "random_id" "random" {
  byte_length = 8
}

locals {
  suffix                       = lower(trimspace(var.use_random_suffix ? substr(lower(random_id.random.hex), 1, 5) : var.suffix))
  name_acr                     = "${var.acr_name}${local.suffix}"
  name_app_insights            = "${var.app_insights_name}-${local.suffix}"
  name_ace                     = "${var.ace_name}-${local.suffix}"
  name_resource_group          = "${var.resource_group_name}-${local.suffix}"
  name_log_analytics_workspace = "${var.log_analytics_workspace_name}-${local.suffix}"
  name_manage_identity         = "${var.managed_identity_name}-${local.suffix}"

  name_aca_ai_agent_proccessor = "${var.aca_ai_agent_proccessor_name}-${local.suffix}"

  tags = merge(var.tags, {
    createdAt   = "${formatdate("YYYY-MM-DD hh:mm:ss", timestamp())} UTC"
    createdWith = "Terraform"
    suffix      = local.suffix
  })
}


resource "azurerm_resource_group" "rg" {
  name     = local.name_resource_group
  location = var.location
  tags     = local.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}


module "acr" {
  source                         = "./modules/acr"
  name                           = local.name_acr
  resource_group_name            = azurerm_resource_group.rg.name
  location                       = var.location
  sku                            = var.acr_sku
  admin_enabled                  = var.acr_admin_enabled
  identity_id                    = module.mi.id
  identity_service_principal_ids = [module.mi.principal_id]
  tags                           = local.tags
}

module "ace" {
  source                                      = "./modules/ace"
  resource_group_name                         = azurerm_resource_group.rg.name
  location                                    = var.ace_location == null ? var.location : var.ace_location
  name                                        = local.name_ace
  dapr_application_insights_connection_string = module.appi.connection_string
  use_infrastructure_resource_group_name      = var.ace_use_infrastructure_resource_group_name
  log_analytics_workspace_id                  = module.log.id
  mutual_tls_enabled                          = var.ace_mutual_tls_enabled
  workload_profile_name                       = var.ace_workload_profile_name
  workload_profile_type                       = var.ace_workload_profile_type
  tags                                        = local.tags
}

module "log" {
  source              = "./modules/log"
  name                = local.name_log_analytics_workspace
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

module "mi" {
  source              = "./modules/mi"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = local.name_manage_identity
  tags                = local.tags
}

module "appi" {
  source                     = "./modules/appi"
  name                       = local.name_app_insights
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = module.log.id
  tags                       = local.tags
}


locals {
  aca_common_environmental_variables = [ 
    {
      name  = "AZURE_CLIENT_ID"
      value = module.mi.client_id
    },
    {
      name  = "AZURE_TENANT_ID"
      value = module.mi.tenant_id
    },
    {
      name  = "ASPNETCORE_ENVIRONMENT"
      value = var.environment
    }
  ]
}


module "aca_ai_agent_proccessor" {
  depends_on = [module.acr] # This dependency is required to ensure that the data for `azurerm_container_registry` reads the ACR successfully, otherwise the plan might throw an error.

  source                                 = "./modules/aca"
  name                                   = local.name_aca_ai_agent_proccessor
  resource_group_name                    = azurerm_resource_group.rg.name
  container_environment_id               = module.ace.id
  revision_mode                          = var.aca_ai_agent_proccessor_revision_mode
  tags                                   = local.tags
  identity_id                            = module.mi.id
  azure_container_registry_name          = module.acr.name
  template_container_name                = var.aca_ai_agent_proccessor_template_container_name
  template_container_image_name          = var.aca_ai_agent_proccessor_template_container_image_name
  template_container_image_tag           = var.aca_ai_agent_proccessor_template_container_image_tag
  template_container_cpu                 = var.aca_ai_agent_proccessor_template_container_cpu
  template_container_memory              = var.aca_ai_agent_proccessor_template_container_memory
  template_max_replicas                  = var.aca_ai_agent_proccessor_template_max_replicas
  template_min_replicas                  = var.aca_ai_agent_proccessor_template_min_replicas
  ingress_external_enabled               = var.aca_ai_agent_proccessor_ingress_external_enabled
  ingress_target_port                    = var.aca_ai_agent_proccessor_ingress_target_port
  ingress_traggic_weight_latest_revision = var.aca_ai_agent_proccessor_ingress_traggic_weight_latest_revision
  ingress_traffic_weight_percentage      = var.aca_ai_agent_proccessor_ingress_traffic_weight_percentage
  dapr_app_id                            = var.aca_ai_agent_proccessor_dapr_app_id
  dapr_app_port                          = var.aca_ai_agent_proccessor_dapr_app_port
  dapr_app_protocol                      = var.aca_ai_agent_proccessor_dapr_app_protocol
  dapr_http_max_request_size             = var.aca_ai_agent_proccessor_dapr_http_max_request_size
  environmental_variables                = local.aca_common_environmental_variables
}