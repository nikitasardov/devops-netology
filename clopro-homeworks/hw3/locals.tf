locals {
  project = "netology"
  env     = "hw15-3"

  kms_key_name = "${local.project}-${local.env}-storage-key"
}
