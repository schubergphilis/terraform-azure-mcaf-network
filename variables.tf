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
    name                    = optional(string, null)
    allocation_method       = optional(string, "Static")
    ddos_protection_mode    = optional(string, "VirtualNetworkInherited")
    ddos_protection_plan_id = optional(string, null)
    domain_name_label       = optional(string, null)
    idle_timeout_in_minutes = optional(number, 4)
    inherit_tags            = optional(bool, true)
    ip_version              = optional(string, "IPv4")
    lock_level              = optional(string, null)
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

variable "subnets" {
  type = map(object({
    name                            = optional(string)
    address_prefix                  = optional(string)
    address_prefixes                = optional(list(string))
    default_outbound_access_enabled = optional(bool, false)
    delegate_to                     = optional(string, null)
    delegate_to_actions             = optional(list(string), null)
    nat_gateway = optional(object({
      id = string
    }))
    no_nsg_association            = optional(bool, false)
    create_network_security_group = optional(bool, false)
    network_security_group_config = optional(object({
      azure_default = optional(bool, false)
    }), null)
    network_security_group_id                     = optional(string, null)
    private_endpoint_network_policies             = optional(string, "Enabled")
    private_link_service_network_policies_enabled = optional(bool, true)
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
    route_table = optional(object({
      id = string
    }))
    service_endpoint_policies = optional(map(object({
      id = string
    })))
    service_endpoints = optional(set(string))
    sharing_scope     = optional(string, null)
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }))
  }))
  default     = {}
  description = <<DESCRIPTION
This object describes the subnets to create within the virtual network.

- `address_prefix`   = (Optional) - The address prefix to use for the subnet. Changing this forces a new resource to be created.
- `address_prefixes` = (Optional) - The address prefixes to use for the subnet. Changing this forces a new resource to be created.
- `name`             = (Optional) - The name of the subnet. Changing this forces a new resource to be created.
- `create_network_security_group` = (Optional) - Whether to create a specific Network Security Group for the subnet. Defaults to false.
- `network_security_group_config` = (Optional) - The configuration for the Network Security Group. Changing this forces a new resource to be created.
  `azure_default` = (Optional) - Whether to use the Azure default Network Security Group rules. Defaults to false.
- `network_security_group_id` = (Optional) - The ID of the Network Security Group to associate with the subnet. Changing this forces a new resource to be created.
- `no_nsg_association` = (Optional) - Whether to associate a Network Security Group with the subnet. Defaults to false.
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
  }
  "DevopsSubnet" = {
    address_prefixes                = ["100.0.2.0/24"]
    default_outbound_access_enabled = false
    delegate_to                     = "Microsoft.ContainerInstance/containerGroups"
    create_network_security_group   = true
  }
  "ToolingSubnet" = {
    address_prefixes                = ["100.0.3.0/24"]
    default_outbound_access_enabled = false
    create_network_security_group   = true
    network_security_group_config = {
      azure_default = true
    }
  }
  "OtherSubnet" = {
    address_prefixes                = ["100.0.4.0/24"]
    default_outbound_access_enabled = false
    no_nsg_association              = true
  }
  "AzureBastionSubnet" = {
    address_prefixes                = ["100.0.5.0/24"]
    default_outbound_access_enabled = false
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

variable "private_dns" {
  type = map(object({
    zone_name           = string
    zone_link_enabled   = optional(bool, true)
    zone_link_name      = optional(string)
    resource_group_name = optional(string)
  }))
  default     = null
  description = <<DESCRIPTION
This object describes the private DNS configuration for the virtual network.

- `zone_name`           = (Required) - The name of the private DNS zone.
- `zone_link_enabled`   = (Optional) - Whether to link the private DNS zone to the virtual network. Defaults to true.
- `zone_link_name`      = (Optional) - The name of the private DNS zone link. Changing this forces a new resource to be created.
- `resource_group_name` = (Optional) - The name of the resource group to link the private DNS zone to. Changing this forces a new resource to be created.

  Example Inputs:

```hcl
private_dns = {
  "keyvault" = {
    zone_name = "privatelink.vaultcore.azure.net"
  }
  "blob" = {
    zone_name = "privatelink.blob.core.windows.net"
  }
  "azurecr" = {
    zone_name = "privatelink.azurecr.io"
  }
}
```hcl

DESCRIPTION
}

variable "public_ip" {
  type = object({
    name              = optional(string, null)
    allocation_method = optional(string, "Static")
    ip_version        = optional(string, "IPv4")
    sku               = optional(string, "Standard")
    sku_tier          = optional(string, "Regional")
    zones             = optional(list(string))
  })
  default     = {}
  nullable    = true
  description = <<DESCRIPTION
This object describes the public IP configuration when creating a public IP.
Its is preconfigured by the Nat Gateway.

- `allocation_method` = (Optional) - Defines the allocation method for this IP address. Possible values are Static or Dynamic, default is Static.
- `ip_version`        = (Optional) - The IP Version to use, IPv6 or IPv4. Changing this forces a new resource to be created. Only static IP address allocation is supported for IPv6, Default is IPv4.
- `name`              = (Optional) - The name of the Public IP. Changing this forces a new resource to be created.
- `sku`               = (Optional) - The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Standard. Changing this forces a new resource to be created.
- `sku_tier`          = (Optional) - The SKU Tier that should be used for the Public IP. Possible values are Regional and Global. Defaults to Regional. Changing this forces a new resource to be created.
- `zones`             = (Optional) - A collection containing the availability zone to allocate the Public IP in. Changing this forces a new resource to be created, Availability Zones are only supported with a Standard SKU and in select regions at this time. Standard SKU Public IP Addresses that do not specify a zone are not zone-redundant by default.
}

DESCRIPTION
}

variable "subnet_delegations_actions" {
  type = map(list(string))
  default = {
    "GitHub.Network/networkSettings"         = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.ApiManagement/service"        = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.App/environments"             = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.App/testClients"              = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Apollo/npu"                   = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.AVS/PrivateClouds"            = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.AzureCosmosDB/clusters"       = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.BareMetal/AzureHPC"           = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.BareMetal/AzureHostedService" = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.BareMetal/AzurePaymentHSM"    = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.BareMetal/AzureVMware" = [
      "Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"
    ]
    "Microsoft.BareMetal/CrayServers" = [
      "Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"
    ]
    "Microsoft.BareMetal/MonitoringServers"       = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Batch/batchAccounts"               = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.CloudTest/hostedpools"             = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.CloudTest/images"                  = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.CloudTest/pools"                   = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Codespaces/plans"                  = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.ContainerInstance/containerGroups" = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.ContainerService/managedClusters"  = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.ContainerService/TestClients"      = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Databricks/workspaces" = [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ]
    "Microsoft.DBforMySQL/flexibleServers"      = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DBforMySQL/servers"              = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DBforMySQL/serversv2"            = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DBforPostgreSQL/flexibleServers" = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DBforPostgreSQL/serversv2"       = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    "Microsoft.DBforPostgreSQL/singleServers"   = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DelegatedNetwork/controller"     = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DevCenter/networkConnection"     = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DocumentDB/cassandraClusters"    = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Fidalgo/networkSettings"         = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.HardwareSecurityModules/dedicatedHSMs" = [
      "Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"
    ]
    "Microsoft.Kusto/clusters"                       = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.LabServices/labplans"                 = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Logic/integrationServiceEnvironments" = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.MachineLearningServices/workspaces"   = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Netapp/volumes" = [
      "Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"
    ]
    "Microsoft.Network/dnsResolvers"                 = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    "Microsoft.Network/fpgaNetworkInterfaces"        = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Network/managedResolvers"             = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Network/networkWatchers."             = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Network/virtualNetworkGateways"       = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Orbital/orbitalGateways"              = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.PowerPlatform/enterprisePolicies"     = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.PowerPlatform/vnetaccesslinks"        = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.ServiceFabricMesh/networks"           = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.ServiceNetworking/trafficControllers" = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Singularity/accounts/networks"        = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Singularity/accounts/npu"             = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Sql/managedInstances" = [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ]
    "Microsoft.Sql/managedInstancesOnebox"    = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Sql/managedInstancesStage"     = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Sql/managedInstancesTest"      = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Sql/servers"                   = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.StoragePool/diskPools"         = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.StreamAnalytics/streamingJobs" = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    "Microsoft.Synapse/workspaces"            = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Web/hostingEnvironments"       = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Web/serverFarms"               = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "NGINX.NGINXPLUS/nginxDeployments"        = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "PaloAltoNetworks.Cloudngfw/firewalls"    = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Qumulo.Storage/fileSystems"              = ["Microsoft.Network/virtualNetworks/subnets/action"]
  }
  description = "List of delegation actions when delegations of subnets is used, will be done for query"
}