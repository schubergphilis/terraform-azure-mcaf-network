# terraform-azure-mcaf-naming
Terraform module to generate virtual network, subnet, dns_zones.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.allow_https_in_from_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_https_out_to_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.deny_any_any_any_in](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.deny_any_any_any_out](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The location/region where the virtual network is created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the virtual network. | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name of the virtual network. | `string` | n/a | yes |
| <a name="input_natgateway"></a> [natgateway](#input\_natgateway) | This object describes the public IP configuration when creating Nat Gateway's with a public IP.  If creating more than one public IP, then these values will be used for all public IPs.<br><br>- `allocation_method`       = (Required) - Defines the allocation method for this IP address. Possible values are Static or Dynamic.<br>- `ddos_protection_mode`    = (Optional) - The DDoS protection mode of the public IP. Possible values are Disabled, Enabled, and VirtualNetworkInherited. Defaults to VirtualNetworkInherited.<br>- `ddos_protection_plan_id` = (Optional) - The ID of DDoS protection plan associated with the public IP. ddos\_protection\_plan\_id can only be set when ddos\_protection\_mode is Enabled<br>- `domain_name_label`       = (Optional) - Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.<br>- `idle_timeout_in_minutes` = (Optional) - Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes.<br>- `inherit_tags`            = (Optional) - Defaults to false.  Set this to false if only the tags defined on this resource should be applied. - Future functionality leaving in.<br>- `ip_version`              = (Optional) - The IP Version to use, IPv6 or IPv4. Changing this forces a new resource to be created. Only static IP address allocation is supported for IPv6.<br>- `lock_level`              = (Optional) - Set this value to override the resource level lock value.  Possible values are `None`, `CanNotDelete`, and `ReadOnly`.<br>- `name`                    = string     - (Required) The name of the public IP. Changing this forces a new resource to be created.<br>- `sku`                     = (Optional) - The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Standard to support zones by default. Changing this forces a new resource to be created. When sku\_tier is set to Global, sku must be set to Standard.<br>- `sku_tier`                = (Optional) - The SKU tier of the Public IP. Accepted values are Global and Regional. Defaults to Regional<br>- `zones`                   = (Optional) - A list of zones where this public IP should be deployed. Defaults to no zone. if you prefer, you can set other values for the zones ["1","2","3"]. Changing this forces a new resource to be created.<br><br>  Example Inputs:<pre>hcl<br>#Standard Regional IPV4 Public IP address configuration<br>public_ip_configuration_details = {<br>  allocation_method       = "Static"<br>  ddos_protection_mode    = "VirtualNetworkInherited"<br>  idle_timeout_in_minutes = 30<br>  ip_version              = "IPv4"<br>  sku_tier                = "Regional"<br>  sku                     = "Standard"<br>}</pre> | <pre>object({<br>    allocation_method       = optional(string, "Static")<br>    ddos_protection_mode    = optional(string, "VirtualNetworkInherited")<br>    ddos_protection_plan_id = optional(string, null)<br>    domain_name_label       = optional(string, null)<br>    idle_timeout_in_minutes = optional(number, 4)<br>    inherit_tags            = optional(bool, true)<br>    ip_version              = optional(string, "IPv4")<br>    lock_level              = optional(string, null)<br>    name                    = optional(string, null)<br>    sku                     = optional(string, "Standard")<br>    sku_tier                = optional(string, "Regional")<br>    zones                   = optional(list(string))<br>  })</pre> | `{}` | no |
| <a name="input_private_dns"></a> [private\_dns](#input\_private\_dns) | The name of the private DNS zone. | <pre>map(object({<br>    zone_name           = string<br>    zone_link_enabled   = optional(bool, true)<br>    zone_link_name      = optional(string)<br>    resource_group_name = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Optional) A map of subnets to create<br><br> - `address_prefix` - (Optional) The address prefix to use for the subnet. One of `address_prefix` or `address_prefixes` must be specified.<br> - `address_prefixes` - (Optional) The address prefixes to use for the subnet. One of `address_prefix` or `address_prefixes` must be specified.<br> - `enforce_private_link_endpoint_network_policies` -<br> - `enforce_private_link_service_network_policies` -<br> - `name` - (Required) The name of the subnet. Changing this forces a new resource to be created.<br> - `default_outbound_access_enabled` - (Optional) Whether to allow internet access from the subnet. Defaults to `false`.<br> - `private_endpoint_network_policies` - (Optional) Enable or Disable network policies for the private endpoint on the subnet. Possible values are `Disabled`, `Enabled`, `NetworkSecurityGroupEnabled` and `RouteTableEnabled`. Defaults to `Enabled`.<br> - `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to `true` will **Enable** the policy and setting this to `false` will **Disable** the policy. Defaults to `true`.<br> - `service_endpoint_policies` - (Optional) The map of objects with IDs of Service Endpoint Policies to associate with the subnet.<br> - `service_endpoints` - (Optional) The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage`, `Microsoft.Storage.Global` and `Microsoft.Web`.<br><br> ---<br> `delegation` supports the following:<br> - `name` - (Required) A name for this delegation.<br><br> ---<br> `nat_gateway` supports the following:<br> - `id` - (Optional) The ID of the NAT Gateway which should be associated with the Subnet. Changing this forces a new resource to be created.<br><br> ---<br> `network_security_group` supports the following:<br> - `id` - (Optional) The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new association to be created.<br><br> ---<br> `route_table` supports the following:<br> - `id` - (Optional) The ID of the Route Table which should be associated with the Subnet. Changing this forces a new association to be created.<br><br> ---<br> `timeouts` supports the following:<br> - `create` - (Defaults to 30 minutes) Used when creating the Subnet.<br> - `delete` - (Defaults to 30 minutes) Used when deleting the Subnet.<br> - `read` - (Defaults to 5 minutes) Used when retrieving the Subnet.<br> - `update` - (Defaults to 30 minutes) Used when updating the Subnet.<br><br> ---<br> `role_assignments` supports the following:<br><br> - `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.<br> - `principal_id` - The ID of the principal to assign the role to.<br> - `description` - (Optional) The description of the role assignment.<br> - `skip_service_principal_aad_check` - (Optional) If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.<br> - `condition` - (Optional) The condition which will be used to scope the role assignment.<br> - `condition_version` - (Optional) The version of the condition syntax. Leave as `null` if you are not using a condition, if you are then valid values are '2.0'.<br> - `delegated_managed_identity_resource_id` - (Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created. This field is only used in cross-tenant scenario.<br> - `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group` and `ServicePrincipal`. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute. | <pre>map(object({<br>    address_prefix   = optional(string)<br>    address_prefixes = optional(list(string))<br>    name             = optional(string)<br>    nat_gateway = optional(object({<br>      id = string<br>    }))<br>    network_security_group = optional(object({<br>      id = string<br>    }))<br>    private_endpoint_network_policies             = optional(string, "Enabled")<br>    private_link_service_network_policies_enabled = optional(bool, true)<br>    route_table = optional(object({<br>      id = string<br>    }))<br>    service_endpoint_policies = optional(map(object({<br>      id = string<br>    })))<br>    service_endpoints               = optional(set(string))<br>    default_outbound_access_enabled = optional(bool, false)<br>    sharing_scope                   = optional(string, null)<br>    delegate_to                     = optional(string, null)<br>    # delegation = optional(list(object({<br>    #   name = string<br>    #   service_delegation = object({<br>    #     name = string<br>    #   })<br>    # })))<br>    timeouts = optional(object({<br>      create = optional(string)<br>      delete = optional(string)<br>      read   = optional(string)<br>      update = optional(string)<br>    }))<br>    role_assignments = optional(map(object({<br>      role_definition_id_or_name             = string<br>      principal_id                           = string<br>      description                            = optional(string, null)<br>      skip_service_principal_aad_check       = optional(bool, false)<br>      condition                              = optional(string, null)<br>      condition_version                      = optional(string, null)<br>      delegated_managed_identity_resource_id = optional(string, null)<br>      principal_type                         = optional(string, null)<br>    })))<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space that is used by the virtual network. | `list(string)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |
| <a name="input_vnet_dns_servers"></a> [vnet\_dns\_servers](#input\_vnet\_dns\_servers) | The DNS servers to be used by the virtual network. | `list(string)` | `[]` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | (Optional) A list of Availability Zones in which this NAT Gateway should be located. Changing this forces a new NAT Gateway to be created. | `set(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the virtual network |
| <a name="output_name"></a> [name](#output\_name) | The name of the virtual network |
| <a name="output_private_dns_zone_list"></a> [private\_dns\_zone\_list](#output\_private\_dns\_zone\_list) | A map of private DNS zone names to their corresponding names and IDs |
| <a name="output_subnet_list"></a> [subnet\_list](#output\_subnet\_list) | A map of subnet names to their corresponding names and IDs |
<!-- END_TF_DOCS -->

## License

**Copyright:** Schuberg Philis

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
