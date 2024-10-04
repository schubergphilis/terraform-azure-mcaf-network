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
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
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
  resource_group_name             = azurerm_virtual_network.this.resource_group_name
  default_outbound_access_enabled = each.value.default_outbound_access_enabled
  virtual_network_name            = azurerm_virtual_network.this.name
  address_prefixes                = each.value.address_prefixes

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

resource "azurerm_network_security_group" "this" {
  name                = "${var.vnet_name}-nsg"
  location            = azurerm_virtual_network.this.location
  resource_group_name = azurerm_virtual_network.this.resource_group_name

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
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this.id
}
