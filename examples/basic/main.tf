terraform {
  required_version = ">= 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4"
    }
  }
}

module "network" {
  source = "../.."

  resource_group = {
    location = "eastus"
    name     = "my-rg"
  }

  vnet_name          = "my-vnet"
  vnet_address_space = ["10.0.0.0/8"]

  natgateway = {
    name = "my-nat-gw"
  }

  subnets = {
    "CoreSubnet" = {
      address_prefixes                = ["100.0.1.0/24"]
      default_outbound_access_enabled = false
      delegate_to                     = "Microsoft.ContainerInstance/containerGroups"
    }
  }

  private_dns = {
    "keyvault" = {
      zone_name = "privatelink.vaultcore.azure.net"
    }
  }

  tags = {
    Environment = "Production"
  }
}
