

variable "security_rules" {
  type = map(object({
    access                                     = string
    name                                       = string
    description                                = optional(string)
    destination_address_prefix                 = optional(string)
    destination_address_prefixes               = optional(set(string))
    destination_application_security_group_ids = optional(set(string))
    destination_port_range                     = optional(string)
    destination_port_ranges                    = optional(set(string))
    direction                                  = string
    priority                                   = number
    protocol                                   = string
    source_address_prefix                      = optional(string)
    source_address_prefixes                    = optional(set(string))
    source_application_security_group_ids      = optional(set(string))
    source_port_range                          = optional(string)
    source_port_ranges                         = optional(set(string))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }))
  }))
  description = <<DESCRIPTION
    A map of security rules to be created in every Network Security Group. The key of the map is the name of the security rule. The value of the map is a map with the following keys.

  - `access` - (Required) Specifies whether network traffic is allowed or denied. Possible values are `Allow` and `Deny`.
  - `name` - (Required) Name of the network security rule to be created.
  - `description` - (Optional) A description for this rule. Restricted to 140 characters.
  - `destination_address_prefix` - (Optional) CIDR or destination IP range or * to match any IP. Tags such as `VirtualNetwork`, `AzureLoadBalancer` and `Internet` can also be used. Besides, it also supports all available Service Tags like ‘Sql.WestEurope‘, ‘Storage.EastUS‘, etc. You can list the available service tags with the CLI: ```shell az network list-service-tags --location westcentralus```. For further information please see [Azure CLI
  - `destination_address_prefixes` - (Optional) List of destination address prefixes. Tags may not be used. This is required if `destination_address_prefix` is not specified.
  - `destination_application_security_group_ids` - (Optional) A List of destination Application Security Group IDs
  - `destination_port_range` - (Optional) Destination Port or Range. Integer or range between `0` and `65535` or `*` to match any. This is required if `destination_port_ranges` is not specified.
  - `destination_port_ranges` - (Optional) List of destination ports or port ranges. This is required if `destination_port_range` is not specified.
  - `direction` - (Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are `Inbound` and `Outbound`.
  - `name` - (Required) The name of the security rule. This needs to be unique across all Rules in the Network Security Group. Changing this forces a new resource to be created.
  - `priority` - (Required) Specifies the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.
  - `protocol` - (Required) Network protocol this rule applies to. Possible values include `Tcp`, `Udp`, `Icmp`, `Esp`, `Ah` or `*` (which matches all).
  - `resource_group_name` - (Required) The name of the resource group in which to create the Network Security Rule. Changing this forces a new resource to be created.
  - `source_address_prefix` - (Optional) CIDR or source IP range or * to match any IP. Tags such as `VirtualNetwork`, `AzureLoadBalancer` and `Internet` can also be used. This is required if `source_address_prefixes` is not specified.
  - `source_address_prefixes` - (Optional) List of source address prefixes. Tags may not be used. This is required if `source_address_prefix` is not specified.
  - `source_application_security_group_ids` - (Optional) A List of source Application Security Group IDs
  - `source_port_range` - (Optional) Source Port or Range. Integer or range between `0` and `65535` or `*` to match any. This is required if `source_port_ranges` is not specified.
  - `source_port_ranges` - (Optional) List of source ports or port ranges. This is required if `source_port_range` is not specified.

  ---
  `timeouts` block supports the following:
  - `create` - (Defaults to 30 minutes) Used when creating the Network Security Rule.
  - `delete` - (Defaults to 30 minutes) Used when deleting the Network Security Rule.
  - `read` - (Defaults to 5 minutes) Used when retrieving the Network Security Rule.
  - `update` - (Defaults to 30 minutes) Used when updating the Network Security Rule.
  DESCRIPTION
  default     = {}
  nullable    = false
}

variable "default_rules" {
  type = map(object({
    access                                     = string
    name                                       = string
    direction                                  = string
    priority                                   = number
    protocol                                   = string
    description                                = optional(string)
    destination_address_prefix                 = optional(string, null)
    destination_address_prefixes               = optional(set(string), null)
    destination_application_security_group_ids = optional(set(string), null)
    destination_port_range                     = optional(string, null)
    destination_port_ranges                    = optional(set(string), null)
    source_address_prefix                      = optional(string, null)
    source_address_prefixes                    = optional(set(string), null)
    source_application_security_group_ids      = optional(set(string), null)
    source_port_range                          = optional(string, null)
    source_port_ranges                         = optional(set(string), null)
    timeouts = optional(object({
      create = optional(string, "30")
      delete = optional(string, "30")
      read   = optional(string, "5")
      update = optional(string, "30")
    }))
  }))
  default = {
    "Allow-Https-in-from-vnets" = {
      access                     = "Allow"
      name                       = "Allow-Https-in-from-vnets"
      description                = "Allow HTTPS traffic from VNets"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "443"
      direction                  = "Inbound"
      priority                   = 4095
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
    },
    "Allow-Https-out-to-vnets" = {
      access                     = "Allow"
      name                       = "Allow-Https-out-to-vnets"
      description                = "Allow HTTPS traffic to VNets"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "443"
      direction                  = "Outbound"
      priority                   = 4095
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"

    },
    "Deny-Any-Any-Any-In" = {
      access                     = "Deny"
      name                       = "Deny-Any-Any-Any-In"
      description                = "Deny all inbound traffic"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      direction                  = "Inbound"
      priority                   = 4096
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    "Deny-Any-Any-Any-Out" = {
      access                     = "Deny"
      name                       = "Deny-Any-Any-Any-Out"
      description                = "Deny all outbound traffic"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      direction                  = "Outbound"
      priority                   = 4096
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }
  }
  nullable = false
}

variable "azure_bastion_security_rules" {
  type = map(object({
    access                                     = string
    name                                       = string
    direction                                  = string
    priority                                   = number
    protocol                                   = string
    description                                = optional(string)
    destination_address_prefix                 = optional(string, null)
    destination_address_prefixes               = optional(set(string), null)
    destination_application_security_group_ids = optional(set(string), null)
    destination_port_range                     = optional(string, null)
    destination_port_ranges                    = optional(set(string), null)
    source_address_prefix                      = optional(string, null)
    source_address_prefixes                    = optional(set(string), null)
    source_application_security_group_ids      = optional(set(string), null)
    source_port_range                          = optional(string, null)
    source_port_ranges                         = optional(set(string), null)
    timeouts = optional(object({
      create = optional(string, "30")
      delete = optional(string, "30")
      read   = optional(string, "5")
      update = optional(string, "30")
    }))
  }))
  default = {
    "Allow-Https-in-from-Internet" = {
      access                     = "Allow"
      name                       = "Allow-Https-in-from-Internet"
      description                = "Allow HTTPS traffic from the Internet"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      direction                  = "Inbound"
      priority                   = 100
      protocol                   = "Tcp"
      source_address_prefix      = "Internet"
      source_port_range          = "*"
    },
    "Allow-Https-in-from-GatewayManager" = {
      access                     = "Allow"
      name                       = "Allow-Https-in-from-GatewayManager"
      description                = "Allow HTTPS traffic from the GatewayManager"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      direction                  = "Inbound"
      priority                   = 101
      protocol                   = "Tcp"
      source_address_prefix      = "GatewayManager"
      source_port_range          = "*"
    },
    "Allow-DataPlane-in-from-VirtualNetwork" = {
      access                     = "Allow"
      name                       = "Allow-DataPlane-in-from-VirtualNetwork"
      description                = "Allow DataPlane traffic from the VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "8080"
      direction                  = "Inbound"
      priority                   = 102
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
    },
    "Allow-DataPlane-in-from-VirtualNetwork-5701" = {
      access                     = "Allow"
      name                       = "Allow-DataPlane-in-from-VirtualNetwork-5701"
      description                = "Allow DataPlane traffic from the VirtualNetwork on port 5701"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "5701"
      direction                  = "Inbound"
      priority                   = 103
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
    },
    "Allow-Https-in-from-AzureLoadBalancer" = {
      access                     = "Allow"
      name                       = "Allow-Https-in-from-AzureLoadBalancer"
      description                = "Allow HTTPS traffic from the AzureLoadBalancer"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      direction                  = "Inbound"
      priority                   = 104
      protocol                   = "Tcp"
      source_address_prefix      = "AzureLoadBalancer"
      source_port_range          = "*"
    },
    "Allow-Rdp-out-to-VirtualNetwork" = {
      access                     = "Allow"
      name                       = "Allow-Rdp-out-to-VirtualNetwork"
      description                = "Allow RDP traffic to the VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "3389"
      direction                  = "Outbound"
      priority                   = 200
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    "Allow-Ssh-out-to-VirtualNetwork" = {
      access                     = "Allow"
      name                       = "Allow-Ssh-out-to-VirtualNetwork"
      description                = "Allow SSH traffic to the VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "22"
      direction                  = "Outbound"
      priority                   = 201
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    "Allow-DataPlane-out-to-VirtualNetwork-8080" = {
      access                     = "Allow"
      name                       = "Allow-DataPlane-out-to-VirtualNetwork-8080"
      description                = "Allow DataPlane traffic to the VirtualNetwork on port 8080"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "8080"
      direction                  = "Outbound"
      priority                   = 202
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    "Allow-DataPlane-out-to-VirtualNetwork-5701" = {
      access                     = "Allow"
      name                       = "Allow-DataPlane-out-to-VirtualNetwork-5701"
      description                = "Allow DataPlane traffic to the VirtualNetwork on port 5701"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "5701"
      direction                  = "Outbound"
      priority                   = 203
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    "Allow-Https-out-to-AzureCloud" = {
      access                     = "Allow"
      name                       = "Allow-Https-out-to-AzureCloud"
      description                = "Allow HTTPS traffic to the AzureCloud"
      destination_address_prefix = "AzureCloud"
      destination_port_range     = "443"
      direction                  = "Outbound"
      priority                   = 204
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    "Allow-Http-out-to-Internet" = {
      access                     = "Allow"
      name                       = "Allow-Http-out-to-Internet"
      description                = "Allow HTTP traffic to the Internet"
      destination_address_prefix = "Internet"
      destination_port_range     = "80"
      direction                  = "Outbound"
      priority                   = 205
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }
  }
  nullable = false
}


# variable "additional_rules" {
#   type = map(object({
#     access                                     = string
#     name                                       = string
#     direction                                  = string
#     priority                                   = number
#     protocol                                   = string
#     description                                = optional(string)
#     destination_address_prefix                 = optional(string, null)
#     destination_address_prefixes               = optional(set(string), null)
#     destination_application_security_group_ids = optional(set(string), null)
#     destination_port_range                     = optional(string, null)
#     destination_port_ranges                    = optional(set(string), null)
#     source_address_prefix                      = optional(string, null)
#     source_address_prefixes                    = optional(set(string), null)
#     source_application_security_group_ids      = optional(set(string), null)
#     source_port_range                          = optional(string, null)
#     source_port_ranges                         = optional(set(string), null)
#     timeouts = optional(object({
#       create = optional(string, "30")
#       delete = optional(string, "30")
#       read   = optional(string, "5")
#       update = optional(string, "30")
#     }))
#   }))
#   default = {
#     "Allow-Https-out-to-Internet" = {
#       access                     = "Allow"
#       name                       = "Allow-Https-out-to-Internet"
#       description                = "Allow HTTPS traffic to the Internet"
#       destination_address_prefix = "Internet"
#       destination_port_range     = "443"
#       direction                  = "Outbound"
#       priority                   = 4090
#       protocol                   = "Tcp"
#       source_address_prefix      = "VirtualNetwork"
#       source_port_range          = "*"
#     },
#     "Allow-ssh-out-to-Internet" = {
#       access                     = "Allow"
#       name                       = "Allow-ssh-out-to-Internet"
#       description                = "Allow SSH traffic to the Internet"
#       destination_address_prefix = "Internet"
#       destination_port_range     = "22"
#       direction                  = "Outbound"
#       priority                   = 4089
#       protocol                   = "Tcp"
#       source_address_prefix      = "VirtualNetwork"
#       source_port_range          = "*"
#     }
#   }
#   nullable = false
# }