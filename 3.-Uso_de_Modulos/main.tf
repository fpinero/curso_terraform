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

#creemos un grupo de recurso que es por donde todo empieza
resource "azurerm_resource_group" "rg_main" {
    location = var.location
    name = var.rg_name
}

#copiado de la web de terraform sección modules
#al estar usando un módulo que no reside en local debemos realizqr un terraform get
module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "2.6.0"
  # insert the 2 required variables here
  resource_group_name = var.rg_name
  vnet_name = var.vnet_name
  address_space = var.vnet_cidr_range
  subnet_prefixes = var.subnet_prefixes
  subnet_names = var.subnet_names
  tags = {
      environment = "dev"
  }

  depends_on = [azurerm_resource_group.rg_main]  

}

