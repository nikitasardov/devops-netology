output "network" {
  value = {
    vpc_id           = yandex_vpc_network.main.id
    public_subnet_id = yandex_vpc_subnet.public.id
  }
}

output "storage" {
  value = {
    bucket_name = yandex_storage_bucket.pictures.bucket
    object_key  = yandex_storage_object.picture.key
    public_url  = "https://storage.yandexcloud.net/${yandex_storage_bucket.pictures.bucket}/${yandex_storage_object.picture.key}"
  }
}

output "instance_group" {
  value = {
    name            = yandex_compute_instance_group.lamp.name
    size            = var.lamp_instance_group_size
    image_id        = var.lamp_image_id
    subnet_id       = yandex_vpc_subnet.public.id
    target_group_id = yandex_compute_instance_group.lamp.load_balancer[0].target_group_id
  }
}

output "load_balancer" {
  value = {
    name        = yandex_lb_network_load_balancer.lamp.name
    external_ip = local.nlb_external_ip
    url         = "http://${local.nlb_external_ip}/"
  }
}
