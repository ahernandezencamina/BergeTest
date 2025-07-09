data "azurerm_container_registry" "acr" {
  name                = var.azure_container_registry_name
  resource_group_name = var.resource_group_name
}

locals {
  dockerfile_path    = "${path.module}/init-app/Dockerfile-${var.template_container_image_name}"
  dockerfile_context = "${path.module}/init-app/"
  dockerfile_content = <<-DOCKERFILE
    FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
    WORKDIR /app

    COPY . ./
    RUN dotnet publish ./*.csproj -c Release -o /app/publish

    FROM mcr.microsoft.com/dotnet/aspnet:8.0
    WORKDIR /app
    COPY --from=build-env /app/publish .
    EXPOSE ${var.ingress_target_port}
    ENTRYPOINT ["dotnet", "Init.dll"]
  DOCKERFILE
  dockerfile_sha1    = sha1(local.dockerfile_content)

  # Directories start with "C:..." on Windows; All other OSs use "/" for root.
  is_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true
}

# resource "terraform_data" "build_aca_initial_app_image" {
#   triggers_replace = {
#     image_name         = var.template_container_image_name
#     image_tag          = var.template_container_image_tag
#     registry_name      = data.azurerm_container_registry.acr.name
#     dockerfile_path    = local.dockerfile_path
#     dockerfile_context = local.dockerfile_context
#     sha1               = local.dockerfile_sha1
#   }

#   # On Windows, commands will be executed in PowerShell 7.x. This is because the `>` operator (an alias for `Out-File`) uses UTF-8 encoding,
#   # unlike the UTF-16 LE BOM encoding used by older versions of PowerShell. Ensuring UTF-8 encoding is crucial as the Dockerfile must be UTF-8 encoded.
#   provisioner "local-exec" {
#     command     = <<-EOT
#       echo '${local.dockerfile_content}' > ${local.dockerfile_path}
#       az acr build -t ${self.triggers_replace.image_name}:${self.triggers_replace.image_tag} -r ${self.triggers_replace.registry_name} -f ${self.triggers_replace.dockerfile_path} ${self.triggers_replace.dockerfile_context}
#     EOT
#     interpreter = local.is_windows ? ["pwsh", "-NoProfile", "-Command"] : []
#   }
# }

resource "azurerm_container_app" "aca" {
 # depends_on = [terraform_data.build_aca_initial_app_image]

  name                         = var.name
  container_app_environment_id = var.container_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = var.revision_mode
  tags                         = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  registry {
    server   = data.azurerm_container_registry.acr.login_server
    identity = var.identity_id
  }

  template {
    max_replicas = var.template_max_replicas
    min_replicas = var.template_min_replicas

    container {
      name   = var.template_container_name
      image  = "${data.azurerm_container_registry.acr.login_server}/${var.template_container_image_name}:${var.template_container_image_tag}"
      cpu    = var.template_container_cpu
      memory = var.template_container_memory

      dynamic "env" {
        for_each = var.environmental_variables != null ? var.environmental_variables : []
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
    }
  }

  ingress {
    external_enabled = var.ingress_external_enabled
    target_port      = var.ingress_target_port

    traffic_weight {
      latest_revision = var.ingress_traggic_weight_latest_revision
      percentage      = var.ingress_traffic_weight_percentage
    }
  }

  dapr {
    app_id       = var.dapr_app_id
    app_port     = var.dapr_app_port
    app_protocol = var.dapr_app_protocol
  }

  lifecycle {
    ignore_changes = [
      tags,
      template[0].container[0].name,
      template[0].container[0].image,
      template[0].container[0].cpu,
      template[0].container[0].memory,      
    ]
  }
}

resource "azapi_update_resource" "update_dapr_http_max_request_size" {
  count       = var.dapr_http_max_request_size != null ? 1 : 0
  type        = "Microsoft.App/containerApps@2024-03-01"
  resource_id = azurerm_container_app.aca.id

  body = jsonencode({
    properties = {
      configuration = {
        dapr = {
          httpMaxRequestSize = var.dapr_http_max_request_size
        }
      }
    }
  })
}
