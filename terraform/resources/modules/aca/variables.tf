variable "resource_group_name" {
  description = "(Required) Specifies the name of the resource group for the Azure Container Application."
  type        = string
  nullable    = false
}

variable "name" {
  description = "(Required) Specifies the name of the Azure Container Application."
  type        = string
  nullable    = false
}

variable "container_environment_id" {
  description = "(Required) The ID of the Container App Environment within which this Container App should exist. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "revision_mode" {
  description = "(Required) The revisions operational mode for the Azure Container Application. Possible values are `Single` and `Multiple`. Defaults to `Single`."
  type        = string
  nullable    = false
  default     = "Single"
}

variable "tags" {
  description = "(Optional) Specifies the tags for this resource."
  type        = map(any)
  default     = {}
}

variable "identity_id" {
  description = "(Required) Specifies a the ID of a User Assigned Managed Identities to be associated with this resource."
  type        = string
  nullable    = false
}

variable "template_container_name" {
  description = "(Required) The name of the container."
  type        = string
  nullable    = false
}

variable "template_container_image_name" {
  description = "(Required) The image to use to create the container. For example, `k8se/quickstart`."
  type        = string
  nullable    = false
  default     = "k8se/quickstart"
}

variable "template_container_image_tag" {
  description = "(Required) The tag to use to create the container. For example, `latest`."
  type        = string
  nullable    = false
  default     = "latest"
}

variable "template_container_cpu" {
  description = "(Required) The amount of virtual CPU (vCPU) to allocate to the container. Possible values include `0.25`, `0.5`, `0.75`, `1.0`, `1.25`, `1.5`, `1.75`, and `2.0`. When there's a workload profile specified, there's no such constraint. Important: CPU and memory must be specified in `0.25/0.5Gi` combination increments, e.g. `1.0/2.0` or `0.5/ 1.0`."
  type        = number
  nullable    = false
  default     = 0.25

  validation {
    condition     = can(regex("^(0.25|0.5|0.75|1.0|1.25|1.5|1.75|2.0)$", var.template_container_cpu))
    error_message = "The CPU must be one of the following values: `0.25`, `0.5`, `0.75`, `1.0`, `1.25`, `1.5`, `1.75`, or `2.0`."
  }
}

variable "template_container_memory" {
  description = "(Required) The amount of memory to allocate to the container. Possible values are `0.5Gi`, `1Gi`, `1.5Gi`, `2Gi`` , `2.5Gi`, `3Gi`, `3.5Gi` and `4Gi`. When there's a workload profile specified, there's no such constraint. Important: CPU and memory must be specified in `0.25/0.5Gi` combination increments, e.g. `1.0/2.0` or `0.5/ 1.0`."
  type        = string
  nullable    = false
  default     = "0.5Gi"

  validation {
    condition     = can(regex("^(0.5Gi|1Gi|1.5Gi|2Gi|2.5Gi|3Gi|3.5Gi|4Gi)$", var.template_container_memory))
    error_message = "The memory must be one of the following values: `0.5Gi`, `1Gi`, `1.5Gi`, `2Gi`, `2.5Gi`, `3Gi`, `3.5Gi`, or `4Gi`."
  }
}

variable "template_max_replicas" {
  description = "(Optional) The maximum number of replicas for this container. Must be a value between `1` and `1000`. Defaults to `10`."
  type        = number
  nullable    = false
  default     = 10

  validation {
    condition     = can(regex("^(1000|[1-9]?[0-9])$", var.template_max_replicas))
    error_message = "The maximum number of replicas must be between 1 and 1000."
  }
}

variable "template_min_replicas" {
  description = "(Optional) The minimum number of replicas for this container. Defaults to `1`."
  type        = number
  nullable    = false
  default     = 1
}

variable "ingress_external_enabled" {
  description = "(Optional) Specifies wheter connections from outside the Container App Environment are enabled or not. Defaults to `false`."
  type        = bool
  nullable    = false
  default     = false
}

variable "ingress_target_port" {
  description = "(Required) The target port on the container for the ingress traffic."
  type        = number
  nullable    = false
  default     = 8080
}

variable "ingress_traggic_weight_latest_revision" {
  description = "(Optional) This traffic Weight applies to the latest stable Container Revision. Defaults to `true`."
  type        = bool
  nullable    = false
  default     = true
}

variable "ingress_traffic_weight_percentage" {
  description = "(Required) The percentage of traffic which should be sent this revision. Defaults to `100`."
  type        = number
  nullable    = false
  default     = 100

  validation {
    condition     = can(regex("^(100|[1-9]?[0-9])$", var.ingress_traffic_weight_percentage))
    error_message = "The percentage must be between 0 and 100."
  }
}

variable "dapr_app_id" {
  description = "(Required) The Dapr Application Identifier."
  type        = string
  nullable    = false
}

variable "dapr_app_port" {
  description = "(Optional) The port which the application is listening on. By default, this is the same as the ingress port in `ingress_target_port` unless specified otherwise."
  type        = number
  nullable    = true
  default     = null
}

variable "dapr_app_protocol" {
  description = "(Optional) The protocol for the app. Possible values are `http` and `grpc`. Defaults to `http`."
  type        = string
  nullable    = false
  default     = "http"

  validation {
    condition     = can(regex("^(http|grpc)$", var.dapr_app_protocol))
    error_message = "The protocol must be either `http` or `grpc`."
  }
}

variable "dapr_http_max_request_size" {
  description = "(Optional) Specifies the max size of request body on `http` and `grpc` servers parameter in MB to handle uploading of big files."
  type        = number
  nullable    = true
  default     = null
}

variable "azure_container_registry_name" {
  description = "(Required) Specifies the name of the Azure Container Registry (ACR)."
  type        = string
  nullable    = false
}

variable "environmental_variables" {
  description = "(Optional) Specifies environmental variables for the container."
  nullable    = true
  type = list(object({
    name  = string
    value = string
  }))
  default = null
}
