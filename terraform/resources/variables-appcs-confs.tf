/*****************************************************************************************
 * This Terraform variables file contains values for the parameters and configurations 
 * managed by an Azure App Configuration service.
 *
 * This is done with each configuration parameter independently - instead of a list or map
 * of configurations - to allow overriding each value independently. Otherwise, the full
 * list or map would need to be provided for just one or two different values.
 ******************************************************************************************/

variable "conf__assistant_options__history_max_tokens" {
  description = "(Required) Specifies the maximum number of tokens to use for chat history. Defaults to `1000`."
  type        = number
  nullable    = false
  default     = 1000
}

variable "conf__assistant_service_options__assistant_http_method_name" {
  description = "(Required) Specifies the HTTP method name to call the AI Assistant service. Defaults to `POST`."
  type        = string
  nullable    = false
  default     = "POST"

  validation {
    condition     = can(regex("^(GET|POST)$", var.conf__assistant_service_options__assistant_http_method_name))
    error_message = "The value must be either `GET` or `POST`."
  }
}

variable "conf__assistant_service_options__assistant_method_template" {
  description = "(Required) Specifies the URL template for the AI Assistant service method."
  type        = string
  nullable    = false
  default     = "api/v$version/AI/Ask"
}

variable "conf__assistant_service_options__assistant_version" {
  description = "(Required) Specifies the version of the AI Assistant service to use. Defaults to `1`."
  type        = number
  nullable    = false
  default     = 1
}

variable "conf__azure_openai_options__chat_model_deployment_name" {
  description = "(Required) Specifies the deployment name of the chat model."
  type        = string
  nullable    = false
  default     = "gpt-4o"
}

variable "conf__azure_openai_options__chat_model_name" {
  description = "(Required) Specifies the name of the chat model. This is also known as the model ID."
  type        = string
  nullable    = false
  default     = "gpt-4o"
}

variable "conf__azure_openai_options__embeddings_model_deployment_name" {
  description = "(Required) Specifies the deployment name of the embeddings model."
  type        = string
  nullable    = false
  default     = "text-embedding-ada-002"
}

variable "conf__azure_openai_options__embeddings_model_name" {
  description = "(Required) Specifies the name of the embeddings model. This is also known as the model ID."
  type        = string
  nullable    = false
  default     = "text-embedding-ada-002"
}

variable "conf__azure_openai_options__use_token_credential_authentication" {
  description = "(Required) Specifies whether to use token credential authentication. Defaults to `false`."
  type        = bool
  nullable    = false
  default     = false
}

variable "conf__azure_openai_options__use_default_azure_credential_authentication" {
  description = "(Required) Specifies whether to use the Azure (default) credential authentication for Azure OpenAI, for example, when integrating with a Manage Identity. Defaults to `true`."
  type        = bool
  nullable    = false
  default     = true
}

variable "conf__chat_history_provider_options__history_max_messages" {
  description = "(Required) Specifies the maximum number of chat history records to return. Defaults to `10`."
  type        = number
  nullable    = false
  default     = 10
}

variable "conf__chitchat_options__persona" {
  description = "(Required) Specifies the persona to use for the chatbot. Available personas are `Professional`, `Friendly`, `Funny`, `Witty`. Defaults to `Professional`."
  type        = string
  nullable    = false
  default     = "Professional"

  validation {
    condition     = can(regex("^(Professional|Friendly|Funny|Witty)$", var.conf__chitchat_options__persona))
    error_message = "The value must be one of `Professional`, `Friendly`, `Funny`, or `Witty`."
  }
}

variable "conf__cosmos_options__use_default_azure_credential_authentication" {
  description = "(Required) Specifies whether to use the Azure (default) credential authentication for Cosmos DB, for example, when integrating with a Manage Identity. Defaults to `true`."
  type        = bool
  nullable    = false
  default     = true
}

variable "conf__default_locale" {
  description = "(Required) Specifies the default locale to use for responses and messages when the user's locale cannot be identified or determined. Defaults to `en`."
  type        = string
  nullable    = false
  default     = "en"
}

variable "conf__detailed_errors" {
  description = "(Required) Specifies whether to return detailed errors. Defaults to `false`."
  type        = bool
  nullable    = false
  default     = false
}

variable "conf_distributed_cache_entry_options__absolute_expiration_relative_to_now" {
  description = "(Required) Specifies the absolute expiration for cache entries relative to now. Format is `HH:MM:SS`. Defaults to `24:00:00` (24 hours)."
  type        = string
  nullable    = false
  default     = "23:59:59"

  validation {
    condition     = can(regex("^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$", var.conf_distributed_cache_entry_options__absolute_expiration_relative_to_now))
    error_message = "The value must be a valid time format in `HH:MM:SS`."
  }
}

variable "conf__sentinel" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for a `Sentinel` which is used to signal changes and refresh configurations on running services."
  type        = string
  nullable    = false
  default     = "1"
}

variable "conf_semaphore_service_options__semaphore_limit" {
  description = "(Required) Specifies the maximum number of concurrent requests allowed. Defaults to `10`."
  type        = number
  nullable    = false
  default     = 10
}


variable "conf__progress_report_chunks_interval" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for an interval progress report of chunks."
  type        = number
  nullable    = false
  default     = 50
}

variable "conf__azure_search_chat_extension_options_document_count" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for a document count of extension options of Azure Search."
  type        = number
  nullable    = false
  default     = 4
}

variable "conf__azure_search_chat_extension_options_max_tokens" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for max tokens of extension options of Azure Search."
  type        = number
  nullable    = false
  default     = 4000
}

variable "conf__azure_search_chat_extension_options_strictness" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for strictness of extension options of Azure Search."
  type        = number
  nullable    = false
  default     = 3
}

variable "conf__azure_search_chat_extension_options_temperature" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for temperature of extension options of Azure Search."
  type        = number
  nullable    = false
  default     = 0.15
}

variable "conf__azure_search_chat_extension_options_top_p" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for top P of extension options of Azure Search."
  type        = number
  nullable    = false
  default     = 1
}

variable "conf__text_splitter_options_chunk_overlap" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for chunk overlap of text splitter options."
  type        = number
  nullable    = false
  default     = 30
}

variable "conf__text_splitter_options_chunk_size" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for chunk size of text splitter options."
  type        = number
  nullable    = false
  default     = 300
}

variable "conf__text_splitter_options_separators" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for separators of text splitter options."
  type        = list(string)
  nullable    = false
  default     = ["\n\r", "\n\n", "\n", ".", "!", "?", ";", ":", ",", " ", ""]
}

variable "conf__question_answering_options_min_relevance_score" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for minimum relevance score of question answering options."
  type        = number
  nullable    = false
  default     = 0.75
}

variable "conf__question_answering_options_results_limit" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for results limit of question answering options."
  type        = number
  nullable    = false
  default     = 5
}

variable "conf__documents_grounding_options_blob_storage_container_name" {
  description = "(Required) In the context of Azure App Configuration, specifies the value for blob storage container name of documents grounding options."
  type        = string
  nullable    = false
  default     = "searchblobcontainer"
}

variable "conf__blob_container_name" {
  description = "(Required) Name of the blob container to store the PDF files"
  type        = string
  default     = "files"
}
