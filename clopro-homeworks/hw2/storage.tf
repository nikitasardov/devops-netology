resource "yandex_iam_service_account" "storage" {
  name      = "${local.project}-${local.env}-storage-sa"
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "storage_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.storage.id}"
}

resource "yandex_iam_service_account_static_access_key" "storage" {
  service_account_id = yandex_iam_service_account.storage.id
  description        = "Object Storage access for hw15.2"
}

resource "yandex_storage_bucket" "pictures" {
  access_key = yandex_iam_service_account_static_access_key.storage.access_key
  secret_key = yandex_iam_service_account_static_access_key.storage.secret_key
  bucket     = var.bucket_name
  folder_id  = var.folder_id

  anonymous_access_flags {
    read = true
  }
}

resource "yandex_storage_object" "picture" {
  access_key   = yandex_iam_service_account_static_access_key.storage.access_key
  secret_key   = yandex_iam_service_account_static_access_key.storage.secret_key
  bucket       = yandex_storage_bucket.pictures.bucket
  key          = var.picture_object_key
  source       = "${path.module}/${var.picture_filename}"
  content_type = "image/jpeg"
  source_hash  = filemd5("${path.module}/${var.picture_filename}")
}
