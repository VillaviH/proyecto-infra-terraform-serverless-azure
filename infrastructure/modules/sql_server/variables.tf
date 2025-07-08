variable "sql_server_name" {
  description = "The name of the SQL Server."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the SQL Server will be created."
  type        = string
}

variable "location" {
  description = "The Azure location where the SQL Server will be created."
  type        = string
}

variable "administrator_login" {
  description = "The administrator login for the SQL Server."
  type        = string
}

variable "administrator_login_password" {
  description = "The password for the SQL Server administrator."
  type        = string
}

variable "database_name" {
  description = "The name of the database."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}