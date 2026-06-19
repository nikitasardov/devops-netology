resource "yandex_vpc_network" "main" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.public_subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = var.public_cidr
}
