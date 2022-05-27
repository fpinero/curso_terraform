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

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "West Europe"
}

resource "azurerm_resource_group" "rg2" {
  name     = "rg2"
  location = "West Europe"
  tags = {
      dependency = azurerm_resource_group.example.name
  }
}

resource "azurerm_resource_group" "rg3" {
  name     = "rg3"
  location = "West Europe"
  depends_on = [
      azurerm_resource_group.rg2
  ]
}

# variables preguntan al usuario
variable "project_name" {
    type = string
    # default = "user_didnot_enter_a_value"
    description = "Nombre del grupo del recurso"
    validation {
        condition = length(var.project_name) > 4
        error_message = "Nombre del grupo de recurso debe tener más de cuatro carácteres."
    }
}

resource "azurerm_resource_group" "examplevariables" {
  name     = "${var.project_name}_main"
  location = "West Europe"
}

# interpolación de cadenas (usar la misma variable como semilla para dos recursos diferentes)
resource "azurerm_resource_group" "examplevariables2" {
  name     = "${var.project_name}_secondary"
  location = "West Europe"
}

# variables locales (no preguntan al usuario)
locals {
    rg1 = azurerm_resource_group.examplevariables2.id
    tag = "development"
    names = {
        name01 = "grupo_recurso_1"
        name02 = "grupo_recurso_2"
        name03 = "grupo_recurso_3"
    }
}

resource "azurerm_resource_group" "examplevariables3" {
  name     = "${var.project_name}_extra"
  location = "West Europe"
  tags = {
      "team" = local.tag
  }
}

# count (crea el recurso las veces que se indique en count)
resource "azurerm_resource_group" "examplevariables4" {
  count    = 3  
  name     = "${var.project_name}_extra${count.index}"
  location = "West Europe"  
}

# for....each ejemplo de uso recorriendo la lista names de locals
resource "azurerm_resource_group" "examplevariablesforeach" {
  for_each = local.names
  name     = "${each.value}"
  location = "West Europe"  
}

variable "rg_count" {
    type = number
}

# definir una variable local añadiendo un if para su valor mínimo
locals {
    # rg_no valdrá el valor que el usuario haya introducido en rg_count si este es mayor de 0
    min_rg_number = 3
    rg_no = var.rg_count > 0 ? var.rg_count : local.min_rg_number
}

resource "azurerm_resource_group" "examplevariable_rg_count" {
  count = local.rg_no
  name     = "grupo_rg_no${count.index}"
  location = "West Europe"  
}

output "output-example" {
    value = azurerm_resource_group.example.id
}

output "output-example-2" {
    value = azurerm_resource_group.example.name
}

# functions
locals {
    person_names = ["Jorge", "Ana", "Héctor", "Alberto"]
    mayus = [for i in local.person_names : upper(i)] # mayus contendrá la lista de person_names en mayúsculas
    a_name = [for i in local.person_names : i if (substr(i,0,1) == "A")] # a_name contendrá los nombre que comiencen por A  
}

output "mayus" {
    value = local.mayus
}

output "empieza_por_A" {
    value = local.a_name
}

# data (llamadas a funciones de recursos del proveedor cloud)
data "azurerm_resource_group" "example" {
  name = "rg-para-pruebas"
}

output "id_de_rg-para-pruebas" {
  value = data.azurerm_resource_group.example.id
}