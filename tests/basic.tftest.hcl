run "basic" {
  variables {
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

  module {
    source = "./"
  }

  command = plan

  assert {
    condition     = output.resource_prefix == "abcdev-shrd-weu-myca"
    error_message = "Unexpected output.resource_prefix value"
  }

  assert {
    condition     = output.subscription == "abcdev-shrd-sub"
    error_message = "Unexpected output.subscription value"
  }
}
