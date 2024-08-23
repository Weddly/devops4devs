terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.116.0"
    }
  }
}

provider "azurerm" {
  features {} # To Use Azure CLI for authentication
}

resource "azurerm_resource_group" "class_rg" {
    name = "class-rg"
    location = "East us"  
}

resource "azurerm_kubernetes_cluster" "class-k8s" {
  name                = var.k8s_name
  location            = azurerm_resource_group.class_rg.location
  resource_group_name = azurerm_resource_group.class_rg.name
  dns_prefix          = "classk8s"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "local_file" "k8s_config" {
  content  = azurerm_kubernetes_cluster.class-k8s.kube_config_raw
  filename = "kube_config_aks.yalm"
}

variable "k8s_name" {
  description = "Kubernetes cluster name"
  type = string
  default = "class-k8s"
}

variable "node_count" {
  description = "Kubernetes cluster node count"
  type = number
  default = 3 
}