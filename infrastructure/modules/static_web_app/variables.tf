variable "static_web_app_name" {
  description = "The name of the Azure Static Web App."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Static Web App will be created."
  type        = string
}

variable "location" {
  description = "The Azure location where the Static Web App will be deployed."
  type        = string
}

variable "app_location" {
  description = "The location of the app source code."
  type        = string
}

variable "api_location" {
  description = "The location of the API source code."
  type        = string
}

variable "output_location" {
  description = "The location of the output files after build."
  type        = string
}