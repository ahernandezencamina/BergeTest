
## ---- COMMON VARIABLES & RESOURCE GROUP ---- ##
variable "development_mode" {
  description = "(Optional) Specifies whether this resource should be created with configurations suitable for develpment purposes. Default is `false`."
  type        = bool
  nullable    = false
  default     = false
}
variable "environment" {
  description = "(Required) Specifies the deployment environment. Possible values are `Development`, `Staging` and `Production`. The values are case-sensitive. Defaults to `Development`."
  type        = string
  nullable    = false
  default     = "Development"
}


variable "subscription_id" {
  description = "(Required) The subscription ID which should be used for deployments. This value is required when performing a `plan`. `apply` or `destroy` operation. Since version 4.0 of the Azure Provider (`azurerm`), it's now required to specify the Azure Subscription ID when configuring a provider instance in the configuration. More info: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide#specifying-subscription-id-is-now-mandatory"
  type        = string
  nullable    = false
}
variable "use_random_suffix" {
  description = "(Required) If `true`, a random suffix is generated and added to the resource groups and its resources. If `false`, the `suffix` variable is used instead. Defaults to `true`."
  type        = bool
  nullable    = false
  default     = true
}

variable "suffix" {
  description = "(Optional) A suffix for the name of the resource group and its resources. If variable `use_random_suffix` is `true`, this variable is ignored. It can only contain letters (any case) and numbers. Defaults to `null`."
  type        = string
  nullable    = true
  default     = null

  validation {
    condition     = can(regex("^[a-zA-Z0-9]*$", var.suffix))
    error_message = "The suffix can only contain letters (any case) and numbers."
  }
}

variable "location" {
  description = "(Required) Specifies the location for the resource group and most of its resources. Defaults to `westeurope`"
  type        = string
  nullable    = false
  default     = "northeurope"
}

variable "tags" {
  description = "(Optional) Specifies tags for all the resources."
  nullable    = false
  default = {
    createdUsing = "Terraform"
  }
}


/* RESOURCE GROUP */

variable "resource_group_name" {
  description = "(Required) The name of the resource group."
  type        = string
  nullable    = false
  default     = "rg-berge-aig"
}

/* CONTAINER ENVIRONMENT */

variable "ace_location" {
  description = "(Optional) Specifies the location of the Azure Container Environment (ACE). If `null`, then the location of the resource group is used. Defaults to `null`."
  type        = string
  nullable    = true
  default     = null
}

variable "ace_name" {
  description = "(Required) Specifies the name of the Azure Container Environment (ACE)."
  type        = string
  nullable    = false
  default     = "ace-berge-aig"
}

variable "ace_use_infrastructure_resource_group_name" {
  description = "(Optional) Specifies whether to use a platform-managed resource group created for the Managed Environment to host infrastructure resources. Defaults to `false`."
  type        = string
  nullable    = false
  default     = false
}

variable "ace_mutual_tls_enabled" {
  description = "(Optional) Specifies whether mutual TLS is enabled for this Container App Environment. Defaults to `false`."
  type        = bool
  nullable    = false
  default     = false
}

variable "ace_workload_profile_name" {
  description = "(Optional) Specifies the name of the workload profile. This value must be `Consumption` when the variable `workload_profile_type` value is `Consumption`. Defaults to `null`. If this value is set, the `workload_profile_type` value must also be set. When `null` the Azure Container Environment (ACE) will use `Consumption Only`."
  type        = string
  nullable    = true
  default     = null

  validation {
    condition     = var.ace_workload_profile_name != "Consumption" || var.ace_workload_profile_type == "Consumption"
    error_message = "The workload profile name must be `Consumption` when the workload profile type is `Consumption`."
  }
}

variable "ace_workload_profile_type" {
  description = "(Optional) Workload profile type for the workloads to run on. Possible values include `Consumption`, `D4`, `D8`, `D16`, `D32`, `E4`, `E8`, `E16` and `E32`. Defaults to `null`. If this value is set, the `workload_profile_name` value must also be set. When `null` the Azure Container Environment (ACE) will use `Consumption Only`."
  type        = string
  nullable    = true
  default     = null

  validation {
    condition     = var.ace_workload_profile_type == null || can(index(["Consumption", "D4", "D8", "D16", "D32", "E4", "E8", "E16", "E32"], var.ace_workload_profile_type))
    error_message = "Invalid workload profile type. Possible values include `Consumption`, `D4`, `D8`, `D16`, `D32`, `E4`, `E8`, `E16` and `E32`."
  }
}

/* LOG ANALYTICS WORKSPACE */

variable "log_analytics_workspace_name" {
  description = "(Required) Specifies the name of the Log Analytics Workspace."
  type        = string
  nullable    = false
  default     = "log-berge-aig"
}

/* MANAGE IDENTITY */

variable "managed_identity_name" {
  description = "(Required) Specifies the name of the Managed Identity."
  type        = string
  nullable    = false
  default     = "id-berge-aig"
}

/* APPLICATION INSIHGTS */

variable "app_insights_name" {
  description = "(Required) Specifies the name of the Application Insights."
  type        = string
  nullable    = false
  default     = "appi-berge-aig"
}

/* CONTAINER REGISTRY */

variable "acr_name" {
  description = "(Required) Specifies the name of the Azure Container Registry."
  type        = string
  nullable    = false
  default     = "acrbergeaig"
}

variable "acr_admin_enabled" {
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to `false`."
  type        = bool
  nullable    = false
  default     = false
}

variable "acr_sku" {
  description = "(Optional) Specifies the sku of the Azure Container Registy. Defaults to `Basic`."
  type        = string
  nullable    = false
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "The Azure Bot sku is incorrect. Possible values are `Basic`, `Standard` or `Premium`."
  }
}
