#Terraform block
# terraform {
#   required_providers {
#     azurerm = {
#       source = "hashicorp/azurerm"
#       version = "3.113.0"
#     }
#   }
# }
terraform {
  required_version = ">= 1.0.0" #terraform cli version
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" #azurerm provider version
    }
    random = { #random provider info
      source = "hashicorp/random" 
      version = ">= 3.0"
    }
    null = {
      source = "hashicorp/null"
      version = ">= 3.0"
    }     
  }
}
#Provider block
provider "azurerm" {
  # Configuration options
  features {}
}