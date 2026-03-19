terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.64.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.3"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "cloudinit" {
}

resource "azurerm_resource_group" "app" {
  name     = "app-resources"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "app" {
  name                = "app-aks1"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  dns_prefix          = "appaks1"

  default_node_pool {
    name       = "default"
    auto_scaling_enabled = true
    min_count = 1
    max_count = 3
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  # As of the time of this assignment's creation, the latest Kubernetes version available is 1.35.0. 
  kubernetes_version = "1.35"
}