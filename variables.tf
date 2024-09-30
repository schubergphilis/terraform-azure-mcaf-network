variable "resource_group" {
  description = "The name of the resource group in which to create the resources."
  type = object({
    name     = string
    location = string
  })
  default = {
    name     = null
    location = null
  }
  nullable = false
}

variable "natgateway" {
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
  default     = null
  nullable    = true
  description = <<DESCRIPTION
This object describes the public IP configuration when creating Nat Gateway's with a public IP.  If creating more than one public IP, then these values will be used for all public IPs.

- `allocation_method`       = (Required) - Defines the allocation method for this IP address. Possible values are Static or Dynamic.
- `ddos_protection_mode`    = (Optional) - The DDoS protection mode of the public IP. Possible values are Disabled, Enabled, and VirtualNetworkInherited. Defaults to VirtualNetworkInherited.
- `ddos_protection_plan_id` = (Optional) - The ID of DDoS protection plan associated with the public IP. ddos_protection_plan_id can only be set when ddos_protection_mode is Enabled
- `domain_name_label`       = (Optional) - Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.
- `idle_timeout_in_minutes` = (Optional) - Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes.
- `inherit_tags`            = (Optional) - Defaults to false.  Set this to false if only the tags defined on this resource should be applied. - Future functionality leaving in.
- `ip_version`              = (Optional) - The IP Version to use, IPv6 or IPv4. Changing this forces a new resource to be created. Only static IP address allocation is supported for IPv6.
- `lock_level`              = (Optional) - Set this value to override the resource level lock value.  Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
- `name`                    = (Optional) - The name of the Nat gateway. Changing this forces a new resource to be created.
- `sku`                     = (Optional) - The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Standard to support zones by default. Changing this forces a new resource to be created. When sku_tier is set to Global, sku must be set to Standard.
- `sku_tier`                = (Optional) - The SKU tier of the Public IP. Accepted values are Global and Regional. Defaults to Regional
- `zones`                   = (Optional) - A list of zones where this public IP should be deployed. Defaults to no zone. if you prefer, you can set other values for the zones ["1","2","3"]. Changing this forces a new resource to be created.

  Example Inputs:

  ```hcl
  natgateway = {
    name = "my-nat-gw"
  }
  ```hcl
DESCRIPTION
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
This object describes the subnets to create within the virtual network.

- `address_prefix`   = (Optional) - The address prefix to use for the subnet. Changing this forces a new resource to be created.
- `address_prefixes` = (Optional) - The address prefixes to use for the subnet. Changing this forces a new resource to be created.
- `name`             = (Optional) - The name of the subnet. Changing this forces a new resource to be created.
- `nat_gateway`      = (Optional) - The NAT Gateway to associate with the subnet. Changing this forces a new resource to be created.
- `network_security_group` = (Optional) - The Network Security Group to associate with the subnet. Changing this forces a new resource to be created.
- `private_endpoint_network_policies` = (Optional) - The network policies for private endpoints on the subnet. Possible values are Enabled and Disabled. Defaults to Enabled.
- `private_link_service_network_policies_enabled` = (Optional) - Enable or disable network policies for private link service on the subnet. Defaults to true.
- `route_table` = (Optional) - The Route Table to associate with the subnet. Changing this forces a new resource to be created.
- `service_endpoint_policies` = (Optional) - The service endpoint policies to associate with the subnet. Changing this forces a new resource to be created.
- `service_endpoints` = (Optional) - The service endpoints to associate with the subnet. Changing this forces a new resource to be created.
- `default_outbound_access_enabled` = (Optional) - Whether to allow outbound traffic from the subnet. Defaults to false.
- `sharing_scope` = (Optional) - The sharing scope of the subnet. Possible values are None, Shared, and Service. Defaults to None.
- `delegate_to` = (Optional) - The service to delegate to. Changing this forces a new resource to be created.
- `timeouts` = (Optional) - The timeouts for the subnet.
- `role_assignments` = (Optional) - The role assignments for the subnet.

  Example Inputs:

  ```hcl
  subnets = {
    "CoreSubnet" = {
      address_prefixes                = ["100.0.1.0/24"]
      default_outbound_access_enabled = false
      delegate_to                     = "Microsoft.ContainerInstance/containerGroups"
    }
  }
  ```hcl


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

variable "public_ip" {
  description = "The name of the public IP."
  type = object({
    allocation_method = optional(string, "Static")
    ip_version        = optional(string, "IPv4")
    name              = optional(string, null)
    sku               = optional(string, "Standard")
    sku_tier          = optional(string, "Regional")
    zones             = optional(list(string))
  })
  default  = {}
  nullable = true
}