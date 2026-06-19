resource "yandex_kms_symmetric_key" "k8s" {
  name              = local.kms_key_name
  description       = "KMS key for Kubernetes etcd encryption (${local.k8s_cluster_name})"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}
