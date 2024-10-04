resource "azurerm_nat_gateway" "this" {
  count = local.natgateway

  name                = var.natgateway.name
  location            = azurerm_virtual_network.this.location
  resource_group_name = azurerm_virtual_network.this.resource_group_name
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
  count = local.natgateway

  name                = var.public_ip.name == null ? "${var.natgateway.name}-pip" : var.public_ip.name
  location            = azurerm_virtual_network.this.location
  resource_group_name = azurerm_virtual_network.this.resource_group_name
  allocation_method   = var.public_ip.allocation_method
  ip_version          = var.public_ip.ip_version
  sku                 = var.public_ip.sku
  sku_tier            = var.public_ip.sku_tier
  zones               = var.public_ip.zones == null ? var.natgateway.zones : var.public_ip.zones

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Public IP"
    })
  )
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  count = local.natgateway

  nat_gateway_id       = azurerm_nat_gateway.this[0].id
  public_ip_address_id = azurerm_public_ip.this[0].id
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = local.natgateway == 1 ? var.subnets : {}

  subnet_id      = azurerm_subnet.this[each.key].id
  nat_gateway_id = azurerm_nat_gateway.this[0].id
}