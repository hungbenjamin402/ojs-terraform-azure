# Environment variable
variable "environment" {
  description = "Environment Name used as prefix"
  type        = string
  default = "dev"
}

# Resource Group name in azure
variable "resource_group_name" {
  description = "Resource Group Name"
  type = string
  default = "rg-ojs"
}

# Azure Resource Location
variable "resource_group_location" {
  description = "Region to create azure resources"
  type = string
  default = "West US" 
}

#admin ojs password
variable "ojs_admin_password" {
  description = "admin password for ojs"
  type        = string
  sensitive   = true
}
variable "ojs_admin_user" {
  description = "admin username for ojs"
  type        = string
}
