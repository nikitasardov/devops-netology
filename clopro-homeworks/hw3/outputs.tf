output "kms" {
  value = {
    key_id   = yandex_kms_symmetric_key.storage.id
    key_name = yandex_kms_symmetric_key.storage.name
  }
}

output "storage" {
  value = {
    bucket_name = yandex_storage_bucket.pictures.bucket
    object_key  = yandex_storage_object.picture.key
    sse_kms_key = yandex_kms_symmetric_key.storage.id
  }
}
