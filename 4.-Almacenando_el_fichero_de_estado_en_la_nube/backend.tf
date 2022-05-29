terraform {
    backend "azurerm" {

    }
    
}

#en la consola ejecutar terraform init -backend-config=backend-config.txt (línea 74 del main.tf)
#de este modo no incluimos información sensible en este fichero tf si no que se lee del arcchivo txt
#q creamos en el main.tf
