terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.7.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features{}
}


resource "azurerm_resource_group" "demo02" {
  name     = "rg-para-pruebas2"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "demo_vnet"
  location            = azurerm_resource_group.demo02.location
  resource_group_name = azurerm_resource_group.demo02.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
  }

  tags = {
    environment = "Production"
  }
}