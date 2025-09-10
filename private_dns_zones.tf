resource "azurerm_private_dns_zone" "this" {
  for_each = var.private_dns != null ? var.private_dns : {}

  name                = each.value.zone_name
  resource_group_name = each.value.resource_group_name == null ? azurerm_resource_group.this.name : each.value.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = var.private_dns != null ? var.private_dns : {}

  name                  = each.value.zone_link_name == null ? "${each.key}_link" : each.value.zone_link_name
  resource_group_name   = each.value.resource_group_name == null ? azurerm_resource_group.this.name : each.value.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name
  virtual_network_id    = azurerm_virtual_network.this.id
  tags                  = var.tags
}