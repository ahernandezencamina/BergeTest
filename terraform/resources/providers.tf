terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.15.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.53.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6.2"
    }
  }

  backend "azurerm" {
  }
}

provider "azuread" {}

provider "azurerm" {  
  subscription_id = var.subscription_id

  features {

       resource_group {
      # This flag is set to mitigate an open bug in Terraform.
      # For instance, the Resource Group is not deleted when a `Failure Anomalies` resource is present.
      # As soon as this is fixed, we should remove this.
      # Reference: https://github.com/hashicorp/terraform-provider-azurerm/issues/18026
      prevent_deletion_if_contains_resources = false
      }
  }
}