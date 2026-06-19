resource "yandex_kms_symmetric_key" "storage" {
  name              = local.kms_key_name
  description       = "SSE-KMS key for Object Storage bucket ${var.bucket_name}"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}
