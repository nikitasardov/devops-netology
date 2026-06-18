output "network" {
  value = {
    vpc_id            = yandex_vpc_network.main.id
    public_subnet_id  = yandex_vpc_subnet.public.id
    private_subnet_id = yandex_vpc_subnet.private.id
    route_table_id    = yandex_vpc_route_table.private.id
  }
}

output "instances" {
  value = {
    nat = {
      name        = yandex_compute_instance.nat.name
      internal_ip = yandex_compute_instance.nat.network_interface[0].ip_address
      external_ip = yandex_compute_instance.nat.network_interface[0].nat_ip_address
    }
    public = {
      name        = yandex_compute_instance.public.name
      internal_ip = yandex_compute_instance.public.network_interface[0].ip_address
      external_ip = yandex_compute_instance.public.network_interface[0].nat_ip_address
    }
    private = {
      name        = yandex_compute_instance.private.name
      internal_ip = yandex_compute_instance.private.network_interface[0].ip_address
    }
  }
}
