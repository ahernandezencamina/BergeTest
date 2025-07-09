resource "azurerm_container_app_environment" "ace" {
  name                               = var.name
  resource_group_name                = var.resource_group_name
  location                           = var.location
  log_analytics_workspace_id         = var.log_analytics_workspace_id
  mutual_tls_enabled                 = var.mutual_tls_enabled
  infrastructure_resource_group_name = var.use_infrastructure_resource_group_name ? "${var.resource_group_name}-ace" : null
  tags                               = var.tags

  # DAPR
  dapr_application_insights_connection_string = var.dapr_application_insights_connection_string


  dynamic "workload_profile" { # This block is only included if the `workload_profile_name` and `workload_profile_type` variables are both set
    for_each = (var.workload_profile_name != null && var.workload_profile_type != null) ? [1] : []

    content {
      name                  = var.workload_profile_name
      workload_profile_type = var.workload_profile_type
    }
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
