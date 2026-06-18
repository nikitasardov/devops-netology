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
  type        = string
  default     = "hw15-vpc"
  description = "VPC network name"
}

variable "public_subnet_name" {
  type    = string
  default = "public"
}

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "private_subnet_name" {
  type    = string
  default = "private"
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "nat_instance_ip" {
  type    = string
  default = "192.168.10.254"
}

variable "nat_image_id" {
  type    = string
  default = "fd80mrhj8fl2oe87o4e1"
}

variable "ubuntu_image_family" {
  type    = string
  default = "ubuntu-2204-lts"
}

variable "vm_platform_id" {
  type    = string
  default = "standard-v3"
}

variable "vm_user" {
  type    = string
  default = "ubuntu"
}

variable "vm_user_nat" {
  type    = string
  default = "nat-instance"
}

variable "ssh_public_key" {
  type = string
}

variable "vm_resources" {
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
  })
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

variable "vm_boot_disk_size" {
  type    = number
  default = 10
}

variable "vm_preemptible" {
  type    = bool
  default = true
}
