resource "azurerm_resource_group" "this" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Resource Group"
    })
  )
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
  dns_servers         = var.vnet_dns_servers
  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Virtual Network"
    })
  )
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                                          = each.value.name != null ? each.value.name : each.key
  resource_group_name                           = azurerm_virtual_network.this.resource_group_name
  default_outbound_access_enabled               = each.value.default_outbound_access_enabled
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = each.value.address_prefixes
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled != null ? each.value.private_link_service_network_policies_enabled : true

  dynamic "delegation" {
    for_each = each.value.delegate_to != null ? [each.value.delegate_to] : []

    content {
      name = split("/", each.value.delegate_to)[1]
      service_delegation {
        name = each.value.delegate_to
      }
    }
  }

  service_endpoints = each.value.service_endpoints

  depends_on = [
    azurerm_virtual_network.this
  ]

  lifecycle {
    ignore_changes = [
      delegation
    ]
  }
}
