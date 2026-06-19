resource "yandex_lb_network_load_balancer" "lamp" {
  name      = local.nlb_name
  folder_id = var.folder_id

  listener {
    name        = "http"
    port        = 80
    target_port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp.load_balancer[0].target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }

  depends_on = [
    yandex_compute_instance_group.lamp,
  ]
}
