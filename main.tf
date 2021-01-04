provider "azurerm" {
    version = "2.5.0"
    features {}
     
}

terraform {
    backend "azurerm" {
        resource_group_name  = "DEV-K8s-RG"
        storage_account_name = "tfstorageaccounttestinv"
        container_name       = "tfstatedevops"
        key                  = "terraform.tfstate"
    }
}

variable "imagebuild" {
  type = string
  description = "Docker Img latest Version Tag"
  
}
resource "azurerm_resource_group" "tf_test" {
    name = "TF_Devops_test_RG"
    location = "Canada Central"
}

resource "azurerm_container_group" "tfcg_test" {
    name = "weatherapi"
    location = azurerm_resource_group.tf_test.location
    resource_group_name = azurerm_resource_group.tf_test.name

    ip_address_type     = "public"
    dns_name_label      = "tfapifirstinv"
    os_type             = "Linux"

    container {
      name            = "weatherapi"
      image           = "gpang2020docker/azuredevopsterraform:${var.imagebuild}"
        cpu             = "1"
        memory          = "1"

        ports {
            port        = 80
            protocol    = "TCP"
         }
    }

}
