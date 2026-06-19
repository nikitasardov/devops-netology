variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "bucket_name" {
  type = string
}

variable "picture_filename" {
  type    = string
  default = "17327109.jpeg"
}

variable "picture_object_key" {
  type    = string
  default = "17327109.jpeg"
}
