resource "yandex_vpc_network" "main" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.public_subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = var.public_cidr
}

resource "yandex_vpc_subnet" "private" {
  for_each = local.private_subnets

  name           = each.value.name
  zone           = each.value.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [each.value.cidr]
}
