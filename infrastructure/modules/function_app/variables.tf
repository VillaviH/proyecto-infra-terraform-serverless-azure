variable "function_app_name" {
  description = "The name of the Azure Function App."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Function App will be deployed."
  type        = string
}

variable "location" {
  description = "The Azure region where the Function App will be deployed."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account used by the Function App."
  type        = string
}

variable "app_insights_name" {
  description = "The name of the Application Insights resource for monitoring."
  type        = string
}

variable "runtime_stack" {
  description = "The runtime stack for the Function App (e.g., dotnet, node, python)."
  type        = string
}

variable "sku" {
  description = "The SKU for the Function App plan."
  type        = string
  default     = "S1"
}

variable "functions_worker_runtime" {
  description = "The worker runtime for the Function App."
  type        = string
  default     = "dotnet"
}