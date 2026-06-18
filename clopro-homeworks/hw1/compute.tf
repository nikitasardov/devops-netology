data "yandex_compute_image" "ubuntu" {
  family = var.ubuntu_image_family
}

resource "yandex_compute_instance" "nat" {
  name        = local.nat_instance_name
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image_id
      type     = "network-hdd"
      size     = var.vm_boot_disk_size
    }
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = var.nat_instance_ip
    nat                = true
    security_group_ids = [yandex_vpc_security_group.nat.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${var.vm_user_nat}:${var.ssh_public_key}"
  }
}

resource "yandex_compute_instance" "public" {
  name        = local.public_vm_name
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = var.vm_boot_disk_size
    }
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.public.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${var.vm_user}:${var.ssh_public_key}"
  }
}

resource "yandex_compute_instance" "private" {
  name        = local.private_vm_name
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = var.vm_boot_disk_size
    }
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.private.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${var.vm_user}:${var.ssh_public_key}"
  }
}
