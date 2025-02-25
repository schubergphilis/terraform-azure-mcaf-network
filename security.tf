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

resource "azurerm_network_security_rule" "default" {
  for_each = local.security_rules

  name                                       = each.value.name
  priority                                   = each.value.priority
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_port_range                          = each.value.source_port_range
  source_port_ranges                         = each.value.source_port_ranges
  destination_port_range                     = each.value.destination_port_range
  destination_port_ranges                    = each.value.destination_port_ranges
  destination_application_security_group_ids = each.value.destination_application_security_group_ids
  source_address_prefix                      = each.value.source_address_prefix
  source_address_prefixes                    = each.value.source_address_prefixes
  source_application_security_group_ids      = each.value.source_application_security_group_ids
  destination_address_prefix                 = each.value.destination_address_prefix
  destination_address_prefixes               = each.value.destination_address_prefixes
  resource_group_name                        = azurerm_network_security_group.this.resource_group_name
  network_security_group_name                = azurerm_network_security_group.this.name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for key, subnet in local.default_subnets : key => subnet if !subnet.no_nsg_association
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.network_security_group_id != null ? each.value.network_security_group_id : azurerm_network_security_group.this.id
}

## Simple NSG, Default Azure
resource "azurerm_network_security_group" "simple" {
  for_each = local.subnets_with_nsg_azure_default

  name                = lower("${var.vnet_name}-${each.key}-nsg")
  location            = azurerm_virtual_network.this.location
  resource_group_name = azurerm_virtual_network.this.resource_group_name

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Network Security Group"
    })
  )
}

resource "azurerm_network_security_rule" "simple" {
  for_each = {
    for item, rule in local.nsg_with_default_security_rules : lower("${rule.subnet_key}_${rule.priority}_${rule.access}_${rule.direction}") => rule
  }

  access                                     = each.value.access
  direction                                  = each.value.direction
  name                                       = each.value.name
  network_security_group_name                = azurerm_network_security_group.simple[each.value.subnet_key].name
  priority                                   = each.value.priority
  protocol                                   = each.value.protocol
  resource_group_name                        = azurerm_network_security_group.this.resource_group_name
  description                                = each.value.description
  destination_address_prefix                 = each.value.destination_address_prefix
  destination_address_prefixes               = each.value.destination_address_prefixes
  destination_application_security_group_ids = each.value.destination_application_security_group_ids
  destination_port_range                     = each.value.destination_port_range
  destination_port_ranges                    = each.value.destination_port_ranges
  source_address_prefix                      = each.value.source_address_prefix
  source_address_prefixes                    = each.value.source_address_prefixes
  source_application_security_group_ids      = each.value.source_application_security_group_ids
  source_port_range                          = each.value.source_port_range
  source_port_ranges                         = each.value.source_port_ranges

  dynamic "timeouts" {
    for_each = each.value.timeouts == null ? [] : [each.value.timeouts]
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }

  # Do not remove this `depends_on` block. It is required to ensure the NSG is created before the rule.
  depends_on = [azurerm_network_security_group.simple]
}

resource "azurerm_subnet_network_security_group_association" "simple" {
  for_each = {
    for key, subnet in local.subnets_with_nsg_azure_default : key => subnet
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.simple[each.key].id
}

### Additional NSGs and rules
resource "azurerm_network_security_group" "additional" {
  for_each = local.subnets_with_nsg

  name                = lower("${var.vnet_name}-${each.key}-nsg")
  location            = azurerm_virtual_network.this.location
  resource_group_name = azurerm_virtual_network.this.resource_group_name

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Network Security Group"
    })
  )
}

resource "azurerm_network_security_rule" "additional" {
  for_each = {
    for item, rule in local.nsg_with_rules : lower("${rule.subnet_key}_${rule.priority}_${rule.access}_${rule.direction}") => rule
  }

  access                                     = each.value.access
  direction                                  = each.value.direction
  name                                       = each.value.name
  network_security_group_name                = azurerm_network_security_group.additional[each.value.subnet_key].name
  priority                                   = each.value.priority
  protocol                                   = each.value.protocol
  resource_group_name                        = azurerm_network_security_group.this.resource_group_name
  description                                = each.value.description
  destination_address_prefix                 = each.value.destination_address_prefix
  destination_address_prefixes               = each.value.destination_address_prefixes
  destination_application_security_group_ids = each.value.destination_application_security_group_ids
  destination_port_range                     = each.value.destination_port_range
  destination_port_ranges                    = each.value.destination_port_ranges
  source_address_prefix                      = each.value.source_address_prefix
  source_address_prefixes                    = each.value.source_address_prefixes
  source_application_security_group_ids      = each.value.source_application_security_group_ids
  source_port_range                          = each.value.source_port_range
  source_port_ranges                         = each.value.source_port_ranges

  dynamic "timeouts" {
    for_each = each.value.timeouts == null ? [] : [each.value.timeouts]
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }

  # Do not remove this `depends_on` block. It is required to ensure the NSG is created before the rule.
  depends_on = [azurerm_network_security_group.additional]
}

resource "azurerm_subnet_network_security_group_association" "additional" {
  for_each = {
    for key, subnet in local.subnets_with_nsg : key => subnet if !subnet.no_nsg_association
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.additional[each.key].id
}

## Azure Bastion NSG and rules
resource "azurerm_network_security_group" "azbastion" {
  for_each = local.azure_bastion_subnet

  name                = lower("${var.vnet_name}-${each.key}-nsg")
  location            = azurerm_virtual_network.this.location
  resource_group_name = azurerm_virtual_network.this.resource_group_name

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Network Security Group"
    })
  )
}

resource "azurerm_network_security_rule" "azbastion" {
  for_each = {
    for item, rule in local.azure_bastion_with_rules : lower("${rule.subnet_key}_${rule.priority}_${rule.access}_${rule.direction}") => rule
  }

  access                                     = each.value.access
  direction                                  = each.value.direction
  name                                       = each.value.name
  network_security_group_name                = azurerm_network_security_group.azbastion[each.value.subnet_key].name
  priority                                   = each.value.priority
  protocol                                   = each.value.protocol
  resource_group_name                        = azurerm_network_security_group.this.resource_group_name
  description                                = each.value.description
  destination_address_prefix                 = each.value.destination_address_prefix
  destination_address_prefixes               = each.value.destination_address_prefixes
  destination_application_security_group_ids = each.value.destination_application_security_group_ids
  destination_port_range                     = each.value.destination_port_range
  destination_port_ranges                    = each.value.destination_port_ranges
  source_address_prefix                      = each.value.source_address_prefix
  source_address_prefixes                    = each.value.source_address_prefixes
  source_application_security_group_ids      = each.value.source_application_security_group_ids
  source_port_range                          = each.value.source_port_range
  source_port_ranges                         = each.value.source_port_ranges

  dynamic "timeouts" {
    for_each = each.value.timeouts == null ? [] : [each.value.timeouts]
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }

  # Do not remove this `depends_on` block. It is required to ensure the NSG is created before the rule.
  depends_on = [azurerm_network_security_group.azbastion]
}

resource "azurerm_subnet_network_security_group_association" "azbastion" {
  for_each = {
    for key, subnet in local.azure_bastion_subnet : key => subnet if !subnet.no_nsg_association
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.azbastion[each.key].id

  depends_on = [azurerm_network_security_rule.azbastion]
}
