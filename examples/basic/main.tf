terraform {
  required_version = ">= 0.13"
}

module "azure_naming" {
  source = "../.."

  customer_tla = "abc"
  environment  = "t01"
  application  = "dtwh"
  location     = "weu"
  workload     = "shrd"
}

output "naming_convention" {
  value = module.azure_naming
}
