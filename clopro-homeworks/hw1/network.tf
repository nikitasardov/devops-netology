resource "yandex_vpc_network" "main" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.public_subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = var.public_cidr
}

resource "yandex_vpc_route_table" "private" {
  name       = local.route_table_name
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat_instance_ip
  }
}

resource "yandex_vpc_subnet" "private" {
  name           = var.private_subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = var.private_cidr
  route_table_id = yandex_vpc_route_table.private.id
}
