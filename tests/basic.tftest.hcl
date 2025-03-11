provider "azurerm" {
  features {}

  subscription_id = "00000000-0000-0000-0000-000000000000"
}

variables {
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

run "setup" {
  module {
    source = "./"
  }
}

run "plan" {
  command = plan

  assert {
    condition     = output.resource_group == "my-rg"
    error_message = "Unexpected output.resource_group value"
  }
}
