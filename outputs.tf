output "name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.this.name
}

output "id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.this.id
}

output "subnet_list" {
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
