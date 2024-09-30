variable "location" {
  description = "The location/region where the virtual network is created."
  type        = string
}

variable "natgateway" {
  nullable = false
  type = object({
    allocation_method       = optional(string, "Static")
    ddos_protection_mode    = optional(string, "VirtualNetworkInherited")
    ddos_protection_plan_id = optional(string, null)
    domain_name_label       = optional(string, null)
    idle_timeout_in_minutes = optional(number, 4)
    inherit_tags            = optional(bool, true)
    ip_version              = optional(string, "IPv4")
    lock_level              = optional(string, null)
    name                    = optional(string, null)
    sku                     = optional(string, "Standard")
    sku_tier                = optional(string, "Regional")
    zones                   = optional(list(string))
  })
  default     = {}
  description = <<PUBLIC_IP_CONFIGURATION_DETAILS
This object describes the public IP configuration when creating Nat Gateway's with a public IP.  If creating more than one public IP, then these values will be used for all public IPs.

- `allocation_method`       = (Required) - Defines the allocation method for this IP address. Possible values are Static or Dynamic.
- `ddos_protection_mode`    = (Optional) - The DDoS protection mode of the public IP. Possible values are Disabled, Enabled, and VirtualNetworkInherited. Defaults to VirtualNetworkInherited.
- `ddos_protection_plan_id` = (Optional) - The ID of DDoS protection plan associated with the public IP. ddos_protection_plan_id can only be set when ddos_protection_mode is Enabled
- `domain_name_label`       = (Optional) - Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.
- `idle_timeout_in_minutes` = (Optional) - Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes.
- `inherit_tags`            = (Optional) - Defaults to false.  Set this to false if only the tags defined on this resource should be applied. - Future functionality leaving in.
- `ip_version`              = (Optional) - The IP Version to use, IPv6 or IPv4. Changing this forces a new resource to be created. Only static IP address allocation is supported for IPv6.
- `lock_level`              = (Optional) - Set this value to override the resource level lock value.  Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
- `name`                    = string     - (Required) The name of the public IP. Changing this forces a new resource to be created.
- `sku`                     = (Optional) - The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Standard to support zones by default. Changing this forces a new resource to be created. When sku_tier is set to Global, sku must be set to Standard.
- `sku_tier`                = (Optional) - The SKU tier of the Public IP. Accepted values are Global and Regional. Defaults to Regional
- `zones`                   = (Optional) - A list of zones where this public IP should be deployed. Defaults to no zone. if you prefer, you can set other values for the zones ["1","2","3"]. Changing this forces a new resource to be created.

  Example Inputs:

```hcl
#Standard Regional IPV4 Public IP address configuration
public_ip_configuration_details = {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  idle_timeout_in_minutes = 30
  ip_version              = "IPv4"
  sku_tier                = "Regional"
  sku                     = "Standard"
}
```
PUBLIC_IP_CONFIGURATION_DETAILS
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  type        = string
}

# source https://github.com/Azure/terraform-azurerm-avm-res-network-virtualnetwork/blob/main/variables.tf#L306
variable "subnets" {
  type = map(object({
    address_prefix   = optional(string)
    address_prefixes = optional(list(string))
    name             = optional(string)
    nat_gateway = optional(object({
      id = string
    }))
    network_security_group = optional(object({
      id = string
    }))
    private_endpoint_network_policies             = optional(string, "Enabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    route_table = optional(object({
      id = string
    }))
    service_endpoint_policies = optional(map(object({
      id = string
    })))
    service_endpoints               = optional(set(string))
    default_outbound_access_enabled = optional(bool, false)
    sharing_scope                   = optional(string, null)
    delegate_to                     = optional(string, null)
    # delegation = optional(list(object({
    #   name = string
    #   service_delegation = object({
    #     name = string
    #   })
    # })))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }))
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })))
  }))
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of subnets to create

 - `address_prefix` - (Optional) The address prefix to use for the subnet. One of `address_prefix` or `address_prefixes` must be specified.
 - `address_prefixes` - (Optional) The address prefixes to use for the subnet. One of `address_prefix` or `address_prefixes` must be specified.
 - `enforce_private_link_endpoint_network_policies` -
 - `enforce_private_link_service_network_policies` -
 - `name` - (Required) The name of the subnet. Changing this forces a new resource to be created.
 - `default_outbound_access_enabled` - (Optional) Whether to allow internet access from the subnet. Defaults to `false`.
 - `private_endpoint_network_policies` - (Optional) Enable or Disable network policies for the private endpoint on the subnet. Possible values are `Disabled`, `Enabled`, `NetworkSecurityGroupEnabled` and `RouteTableEnabled`. Defaults to `Enabled`.
 - `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to `true` will **Enable** the policy and setting this to `false` will **Disable** the policy. Defaults to `true`.
 - `service_endpoint_policies` - (Optional) The map of objects with IDs of Service Endpoint Policies to associate with the subnet.
 - `service_endpoints` - (Optional) The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage`, `Microsoft.Storage.Global` and `Microsoft.Web`.

 ---
 `delegation` supports the following:
 - `name` - (Required) A name for this delegation.

 ---
 `nat_gateway` supports the following:
 - `id` - (Optional) The ID of the NAT Gateway which should be associated with the Subnet. Changing this forces a new resource to be created.

 ---
 `network_security_group` supports the following:
 - `id` - (Optional) The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new association to be created.

 ---
 `route_table` supports the following:
 - `id` - (Optional) The ID of the Route Table which should be associated with the Subnet. Changing this forces a new association to be created.

 ---
 `timeouts` supports the following:
 - `create` - (Defaults to 30 minutes) Used when creating the Subnet.
 - `delete` - (Defaults to 30 minutes) Used when deleting the Subnet.
 - `read` - (Defaults to 5 minutes) Used when retrieving the Subnet.
 - `update` - (Defaults to 30 minutes) Used when updating the Subnet.

 ---
 `role_assignments` supports the following:

 - `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
 - `principal_id` - The ID of the principal to assign the role to.
 - `description` - (Optional) The description of the role assignment.
 - `skip_service_principal_aad_check` - (Optional) If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
 - `condition` - (Optional) The condition which will be used to scope the role assignment.
 - `condition_version` - (Optional) The version of the condition syntax. Leave as `null` if you are not using a condition, if you are then valid values are '2.0'.
 - `delegated_managed_identity_resource_id` - (Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created. This field is only used in cross-tenant scenario.
 - `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group` and `ServicePrincipal`. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.

DESCRIPTION

  validation {
    condition     = alltrue([for _, subnet in var.subnets : subnet.address_prefix != null || subnet.address_prefixes != null])
    error_message = "One of `address_prefix` or `address_prefixes` must be set."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "vnet_address_space" {
  description = "The address space that is used by the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "vnet_dns_servers" {
  description = "The DNS servers to be used by the virtual network."
  type        = list(string)
  default     = []
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "zones" {
  type        = set(string)
  default     = null
  description = "(Optional) A list of Availability Zones in which this NAT Gateway should be located. Changing this forces a new NAT Gateway to be created."
}

# variable "private_dns_zone" {
#   description = "The name of the private DNS zone."
#   type        = set(string)
#   default     = null
# }

variable "private_dns" {
  description = "The name of the private DNS zone."
  type = map(object({
    zone_name           = string
    zone_link_enabled   = optional(bool, true)
    zone_link_name      = optional(string)
    resource_group_name = optional(string)
  }))
  default = null
}
