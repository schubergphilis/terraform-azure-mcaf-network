locals {
  natgateway = length(var.natgateway) > 0 ? 1 : 0
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
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

  name                            = each.value.name != null ? each.value.name : each.key
  resource_group_name             = var.resource_group_name
  default_outbound_access_enabled = each.value.default_outbound_access_enabled
  virtual_network_name            = azurerm_virtual_network.this.name
  address_prefixes                = each.value.address_prefixes

  dynamic "delegation" {
    for_each = each.value.delegate_to != null ? [each.value.delegate_to] : []
    content {
      name = "something"
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

resource "azurerm_network_security_group" "this" {
  name                = "${var.vnet_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Network Security Group"
    })
  )
}

resource "azurerm_network_security_rule" "allow_https_in_from_vnets" {
  name                        = "Allow-Https-in-from-vnets"
  priority                    = 4095
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_network_security_group.this.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "allow_https_out_to_vnets" {
  name                        = "Allow-Https-out-to-vnets"
  priority                    = 4095
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_network_security_group.this.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "deny_any_any_any_in" {
  name                        = "Deny-Any-Any-Any-In"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.this.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "deny_any_any_any_out" {
  name                        = "Deny-Any-Any-Any-Out"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.this.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = var.subnets
  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_nat_gateway" "this" {
  count = local.natgateway

  name                = var.natgateway.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.natgateway.sku
  zones               = var.natgateway.zones

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "NAT Gateway"
    })
  )
}

resource "azurerm_public_ip" "this" {
  count               = local.natgateway
  name                = "${var.natgateway.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  count                = local.natgateway
  nat_gateway_id       = azurerm_nat_gateway.this[0].id
  public_ip_address_id = azurerm_public_ip.this[0].id
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each       = local.natgateway == 1 ? var.subnets : {}
  subnet_id      = azurerm_subnet.this[each.key].id
  nat_gateway_id = azurerm_nat_gateway.this[0].id
}
