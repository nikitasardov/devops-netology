resource "yandex_vpc_network" "main" {
  name = var.vpc_name
}

moved {
  from = yandex_vpc_subnet.public
  to   = yandex_vpc_subnet.public["a"]
}

resource "yandex_vpc_subnet" "public" {
  for_each = local.public_subnets

  name           = each.value.name
  zone           = each.value.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [each.value.cidr]
}

resource "yandex_vpc_subnet" "private" {
  for_each = local.private_subnets

  name           = each.value.name
  zone           = each.value.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [each.value.cidr]
}
