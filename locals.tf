locals {
  natgateway = var.natgateway == null ? 0 : 1

  # Subnet selections
  default_subnets      = { for k, v in var.subnets : k => v if !v.create_network_security_group && k != "AzureBastionSubnet" }
  azure_bastion_subnet = { for k, v in var.subnets : k => v if k == "AzureBastionSubnet" }

  subnets_with_nsg = {
    for k, v in var.subnets :
    k => v if(
      v.create_network_security_group &&
      v.network_security_group_config == null &&
      k != "AzureBastionSubnet"
    )
  }

  subnets_with_nsg_azure_default = {
    for k, v in var.subnets :
    k => v if(
      v.create_network_security_group &&
      try(v.network_security_group_config.azure_default, false) &&
      k != "AzureBastionSubnet"
    )
  }

  ## Security rules
  preprocessed_security_rules = { for key, rule in var.security_rules : rule.name => rule }
  security_rules              = merge(var.default_rules, local.preprocessed_security_rules)
  azure_bastion_rules_map     = merge(var.azure_bastion_security_rules, local.security_rules)

  nsg_with_rules = flatten([
    for subnet_key, subnet in local.subnets_with_nsg : [
      for rule_key, rule in local.security_rules : {
        subnet_key                                 = subnet_key
        name                                       = rule_key
        description                                = rule.description
        priority                                   = rule.priority
        direction                                  = rule.direction
        access                                     = rule.access
        protocol                                   = rule.protocol
        source_port_range                          = rule.source_port_range
        source_port_ranges                         = rule.source_port_ranges
        destination_port_range                     = rule.destination_port_range
        destination_port_ranges                    = rule.destination_port_ranges
        source_address_prefix                      = rule.source_address_prefix
        source_address_prefixes                    = rule.source_address_prefixes
        source_application_security_group_ids      = rule.source_application_security_group_ids
        destination_address_prefix                 = rule.destination_address_prefix
        destination_address_prefixes               = rule.destination_address_prefixes
        destination_application_security_group_ids = rule.destination_application_security_group_ids
        timeouts                                   = rule.timeouts
      }
    ]
  ])

  nsg_with_default_security_rules = flatten([
    for subnet_key, subnet in local.subnets_with_nsg_azure_default : [
      for rule_key, rule in local.preprocessed_security_rules : {
        subnet_key                                 = subnet_key
        name                                       = rule_key
        description                                = rule.description
        priority                                   = rule.priority
        direction                                  = rule.direction
        access                                     = rule.access
        protocol                                   = rule.protocol
        source_port_range                          = rule.source_port_range
        source_port_ranges                         = rule.source_port_ranges
        destination_port_range                     = rule.destination_port_range
        destination_port_ranges                    = rule.destination_port_ranges
        source_address_prefix                      = rule.source_address_prefix
        source_address_prefixes                    = rule.source_address_prefixes
        source_application_security_group_ids      = rule.source_application_security_group_ids
        destination_address_prefix                 = rule.destination_address_prefix
        destination_address_prefixes               = rule.destination_address_prefixes
        destination_application_security_group_ids = rule.destination_application_security_group_ids
        timeouts                                   = rule.timeouts
      }
    ]
  ])

  azure_bastion_security_rules = {
    for rule_key, rule in local.azure_bastion_rules_map : rule_key => rule_key == "Allow-Https-in-from-Internet" ? merge(rule, {
      source_address_prefixes = var.azure_bastion_source_ip_prefixes
    }) : rule
  }

  azure_bastion_with_rules = flatten([
    for subnet_key, subnet in local.azure_bastion_subnet : [
      for rule_key, rule in local.azure_bastion_security_rules : {
        subnet_key                                 = subnet_key
        name                                       = rule_key
        description                                = rule.description
        priority                                   = rule.priority
        direction                                  = rule.direction
        access                                     = rule.access
        protocol                                   = rule.protocol
        source_port_range                          = rule.source_port_range
        source_port_ranges                         = rule.source_port_ranges
        destination_port_range                     = rule.destination_port_range
        destination_port_ranges                    = rule.destination_port_ranges
        source_address_prefix                      = rule.source_address_prefix
        source_address_prefixes                    = rule.source_address_prefixes
        source_application_security_group_ids      = rule.source_application_security_group_ids
        destination_address_prefix                 = rule.destination_address_prefix
        destination_address_prefixes               = rule.destination_address_prefixes
        destination_application_security_group_ids = rule.destination_application_security_group_ids
        timeouts                                   = rule.timeouts
      }
    ]
  ])

  all_custom_network_security_groups = merge(
    azurerm_network_security_group.additional,
    azurerm_network_security_group.simple,
    azurerm_network_security_group.azbastion
  )
}

