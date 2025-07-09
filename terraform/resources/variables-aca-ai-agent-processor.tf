/***********************************************************************************************
 * This Terraform variables file contains values for the parameters and configurations 
 * required by the Azure Container Application (ACA) hosting the `AI Agent - Chitchat` service.
 ***********************************************************************************************/

variable "aca_ai_agent_proccessor_name" {
  description = "(Required) Specifies the name of the Azure Container Application."
  type        = string
  nullable    = false
  default     = "aca-ai-agent-proccessor"
}

variable "aca_ai_agent_proccessor_revision_mode" {
  description = "(Required) The revisions operational mode for the Azure Container Application. Possible values are `Single` and `Multiple`. Defaults to `Single`."
  type        = string
  nullable    = false
  default     = "Single"
}

variable "aca_ai_agent_proccessor_template_container_name" {
  description = "(Required) The name of the container."
  type        = string
  nullable    = false
  default     = "container-ai-agent-proccessor"
}

variable "aca_ai_agent_proccessor_template_container_image_name" {
  description = "(Required) The image to use to create the container. For example, `berge-ai-services-agents-proccessor`."
  type        = string
  nullable    = false
  default     = "berge-ai-services-agents-proccessor"
}

variable "aca_ai_agent_proccessor_template_container_image_tag" {
  description = "(Required) The tag to use to create the container. For example, `latest`."
  type        = string
  nullable    = false
  default     = "latest"
}

variable "aca_ai_agent_proccessor_template_container_cpu" {
  description = "(Required) The amount of virtual CPU (vCPU) to allocate to the container. Possible values include `0.25`, `0.5`, `0.75`, `1.0`, `1.25`, `1.5`, `1.75`, and `2.0`. When there's a workload profile specified, there's no such constraint. Important: CPU and memory must be specified in `0.25/0.5Gi` combination increments, e.g. `1.0/2.0` or `0.5/ 1.0`."
  type        = number
  nullable    = false
  default     = 0.25
}

variable "aca_ai_agent_proccessor_template_container_memory" {
  description = "(Required) The amount of memory to allocate to the container. Possible values are `0.5Gi`, `1Gi`, `1.5Gi`, `2Gi`` , `2.5Gi`, `3Gi`, `3.5Gi` and `4Gi`. When there's a workload profile specified, there's no such constraint. Important: CPU and memory must be specified in `0.25/0.5Gi` combination increments, e.g. `1.0/2.0` or `0.5/ 1.0`."
  type        = string
  nullable    = false
  default     = "0.5Gi"
}

variable "aca_ai_agent_proccessor_template_max_replicas" {
  description = "(Optional) The maximum number of replicas for this container. Must be a value between `1` and `1000`. Defaults to `10`."
  type        = number
  nullable    = false
  default     = 10

  validation {
    condition     = can(regex("^(1000|[1-9]?[0-9])$", var.aca_ai_agent_proccessor_template_max_replicas))
    error_message = "The maximum number of replicas must be between 1 and 1000."
  }
}

variable "aca_ai_agent_proccessor_template_min_replicas" {
  description = "(Optional) The minimum number of replicas for this container. Defaults to `1`."
  type        = number
  nullable    = false
  default     = 1
}

variable "aca_ai_agent_proccessor_ingress_external_enabled" {
  description = "(Optional) Specifies wheter connections from outside the Container App Environment are enabled or not. Defaults to `false`."
  type        = bool
  nullable    = false
  default     = false
}

variable "aca_ai_agent_proccessor_ingress_target_port" {
  description = "(Required) The target port on the container for the ingress traffic."
  type        = number
  nullable    = false
  default     = 8080
}

variable "aca_ai_agent_proccessor_ingress_traggic_weight_latest_revision" {
  description = "(Optional) This traffic Weight applies to the latest stable Container Revision. Defaults to `true`."
  type        = bool
  nullable    = false
  default     = true
}

variable "aca_ai_agent_proccessor_ingress_traffic_weight_percentage" {
  description = "(Required) The percentage of traffic which should be sent this revision. Defaults to `100`."
  type        = number
  nullable    = false
  default     = 100
}

variable "aca_ai_agent_proccessor_dapr_app_id" {
  description = "(Required) The Dapr Application Identifier."
  type        = string
  nullable    = false
  default     = "ai-agent-chitchat"
}

variable "aca_ai_agent_proccessor_dapr_app_port" {
  description = "(Optional) The port which the application is listening on. By default, this is the same as the ingress port in `ingress_target_port` unless specified otherwise."
  type        = number
  nullable    = true
  default     = null
}

variable "aca_ai_agent_proccessor_dapr_app_protocol" {
  description = "(Optional) The protocol for the app. Possible values are `http` and `grpc`. Defaults to `http`."
  type        = string
  nullable    = false
  default     = "http"
}

variable "aca_ai_agent_proccessor_dapr_http_max_request_size" {
  description = "(Optional) Specifies the max size of request body on `http` and `grpc` servers parameter in MB to handle uploading of big files."
  type        = number
  nullable    = true
  default     = null
}
