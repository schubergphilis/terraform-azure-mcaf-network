terraform {
  required_version = ">= 1.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4"
    }
  }
}

module "network_ngw" {
  source = "../.."

  resource_group_name = "example-rsg"

  vnet_name          = "my-vnet"
  vnet_address_space = ["10.0.0.0/8"]

  natgateway = {
    name = "my-nat-gw"
  }

  subnets = {
    "CoreSubnet" = {
      address_prefixes                  = ["100.0.1.0/24"]
      default_outbound_access_enabled   = false
      delegate_to                       = "Microsoft.ContainerInstance/containerGroups"
      private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
    }
  }

  private_dns = {
    "keyvault" = {
      zone_name = "privatelink.vaultcore.azure.net"
    }
  }

  location = "eastus"

  tags = {
    Environment = "Production"
  }
}

module "network_ngw_byoip" {
  source = "../.."

  resource_group_name = "example-rsg"

  vnet_name          = "my-vnet"
  vnet_address_space = ["10.0.0.0/8"]

  natgateway = {
    name                 = "my-nat-gw"
    public_ip_address_id = "azurerm_public_ip.this.id"
  }

  public_ip = null

  subnets = {
    "CoreSubnet" = {
      address_prefixes                  = ["100.0.1.0/24"]
      default_outbound_access_enabled   = false
      delegate_to                       = "Microsoft.ContainerInstance/containerGroups"
      private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
    }
  }

  private_dns = {
    "keyvault" = {
      zone_name = "privatelink.vaultcore.azure.net"
    }
  }

  location = "eastus"

  tags = {
    Environment = "Production"
  }
}


