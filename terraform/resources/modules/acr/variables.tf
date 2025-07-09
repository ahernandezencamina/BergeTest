variable "resource_group_name" {
  description = "(Required) Specifies the name of the resource group for the Azure Container Registry."
  type        = string
  nullable    = false
}

variable "location" {
  description = "(Required) Specifies the location of the Azure Container Registry."
  type        = string
  nullable    = false
}

variable "name" {
  description = "(Required) Specifies the name of the Azure Container Registry."
  type        = string
  nullable    = false
}

variable "admin_enabled" {
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to `false`."
  type        = bool
  nullable    = false
  default     = false
}

variable "identity_id" {
  description = "(Required) Specifies a the ID of a User Assigned Managed Identities to be associated with this resource."
  type        = string
  nullable    = false
}

variable "identity_service_principal_ids" {
  description = "(Optional) Specifies a list Service Principal IDs for proper role assigments associated with this resource."
  type        = list(string)
  nullable    = false
  default     = []
}

variable "sku" {
  description = "(Optional) Specifies the sku of the Azure Container Registy. Defaults to `Basic`."
  type        = string
  nullable    = false
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "The Azure Bot sku is incorrect. Possible values are `Basic`, `Standard` or `Premium`."
  }
}

variable "tags" {
  description = "(Optional) Specifies the tags for this resource."
  type        = map(any)
  default     = {}
}
