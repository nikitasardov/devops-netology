variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vpc_name" {
  type    = string
  default = "netology-hw15-4-vpc"
}

variable "mysql_version" {
  type    = string
  default = "8.0"
}

variable "mysql_resource_preset_id" {
  type        = string
  default     = "b1.medium"
  description = "Intel Broadwell, 50% CPU"
}

variable "mysql_disk_type_id" {
  type    = string
  default = "network-ssd"
}

variable "mysql_disk_size" {
  type    = number
  default = 20
}

variable "mysql_db_name" {
  type    = string
  default = "netology_db"
}

variable "mysql_user" {
  type    = string
  default = "netology"
}

variable "mysql_password" {
  type      = string
  sensitive = true
}

variable "k8s_version" {
  type    = string
  default = "1.31"
}

variable "k8s_node_platform_id" {
  type    = string
  default = "standard-v3"
}

variable "k8s_node_cores" {
  type    = number
  default = 2
}

variable "k8s_node_memory" {
  type    = number
  default = 4
}

variable "k8s_node_disk_type" {
  type    = string
  default = "network-hdd"
}

variable "k8s_node_disk_size" {
  type    = number
  default = 64
}

variable "k8s_node_min" {
  type    = number
  default = 3
}

variable "k8s_node_max" {
  type    = number
  default = 6
}

variable "k8s_node_initial" {
  type    = number
  default = 3
}
