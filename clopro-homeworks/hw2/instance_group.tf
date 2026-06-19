resource "yandex_iam_service_account" "ig" {
  name      = "${local.project}-${local.env}-ig-sa"
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "ig_roles" {
  for_each = toset([
    "compute.editor",
    "vpc.user",
    "load-balancer.editor",
  ])

  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.ig.id}"
}

resource "yandex_compute_instance_group" "lamp" {
  name               = local.lamp_ig_name
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.ig.id

  instance_template {
    platform_id = var.vm_platform_id

    resources {
      cores         = var.vm_resources.cores
      memory        = var.vm_resources.memory
      core_fraction = var.vm_resources.core_fraction
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.lamp_image_id
        size     = var.vm_boot_disk_size
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id         = yandex_vpc_network.main.id
      subnet_ids         = [yandex_vpc_subnet.public.id]
      security_group_ids = [yandex_vpc_security_group.lamp.id]
      nat                = false
    }

    metadata = {
      user-data          = local.lamp_user_data
      ssh-keys           = "${var.vm_user}:${var.ssh_public_key}"
      serial-port-enable = "1"
    }

    scheduling_policy {
      preemptible = var.vm_preemptible
    }
  }

  scale_policy {
    fixed_scale {
      size = var.lamp_instance_group_size
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 3
  }

  health_check {
    interval            = 10
    timeout             = 3
    unhealthy_threshold = 3
    healthy_threshold   = 2

    http_options {
      port = 80
      path = "/"
    }
  }

  depends_on = [
    yandex_storage_object.picture,
  ]

  load_balancer {
    target_group_name        = local.lamp_tg_name
    target_group_description = "NLB target group for ${local.lamp_ig_name}"
  }
}
