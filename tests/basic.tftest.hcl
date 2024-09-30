run "basic" {
  variables {
    application  = "myca"
    customer_tla = "abc"
    environment  = "dev"
    location     = "weu"
    workload     = "shrd"
  }

  module {
    source = "./"
  }

  command = plan

  assert {
    condition     = output.resource_prefix == "abcdev-shrd-weu-myca"
    error_message = "Unexpected output.resource_prefix value"
  }

  assert {
    condition     = output.subscription == "abcdev-shrd-sub"
    error_message = "Unexpected output.subscription value"
  }
}
