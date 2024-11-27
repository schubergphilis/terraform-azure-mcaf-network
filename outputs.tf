output "name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.this.name
}

output "resource_group" {
  description = "The resource group in which the virtual network is created"
  value       = azurerm_resource_group.this
}

output "id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.this.id
}

output "subnets" {
  description = "A map of subnet names to their corresponding names and IDs"
  value = {
    for subnet in azurerm_subnet.this : subnet.name => {
      name = subnet.name
      id   = subnet.id
    }
  }
}

output "private_dns_zone_list" {
  description = "A map of private DNS zone names to their corresponding names and IDs"
  value = {
    for private_dns_zone in azurerm_private_dns_zone.this : private_dns_zone.name => {
      name = private_dns_zone.name
      id   = private_dns_zone.id
    }
  }
}

output "all_subnets" {
  description = "A list of all subnets created"
  value = [for subnet in azurerm_subnet.this : {
    name = subnet.name
    id   = subnet.id
  }]
}

output "all_network_security_groups" {
  description = "A map of all network security groups created keyed by subnet"
  value = { for subnet, nsg in local.all_custom_network_security_groups : subnet => {
    name     = nsg.name
    id       = nsg.id
    location = nsg.location
  } }
}

output "subnets_with_nsg" {
  value = local.subnets_with_nsg
}

output "subnets_with_nsg_azure_default" {
  value = local.subnets_with_nsg_azure_default
}

output "subnets_with_default_nsg" {
  value = local.default_subnets
}
