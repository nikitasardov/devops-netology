resource "yandex_iam_service_account" "k8s_cluster" {
  name      = local.k8s_cluster_sa_name
  folder_id = var.folder_id
}

resource "yandex_iam_service_account" "k8s_node" {
  name      = local.k8s_node_sa_name
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_cluster_agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_vpc_public_admin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_lb_admin" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_storage_editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_kms" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_cluster.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_node_agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_node.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_node_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_node.id}"
}

resource "yandex_kubernetes_cluster" "main" {
  name        = local.k8s_cluster_name
  network_id  = yandex_vpc_network.main.id
  description = "Regional Kubernetes cluster for hw15.4"

  service_account_id      = yandex_iam_service_account.k8s_cluster.id
  node_service_account_id = yandex_iam_service_account.k8s_node.id

  release_channel = "STABLE"

  kms_provider {
    key_id = yandex_kms_symmetric_key.k8s.id
  }

  master {
    regional {
      region = "ru-central1"

      dynamic "location" {
        for_each = local.k8s_zones
        content {
          zone      = local.public_subnets[location.value].zone
          subnet_id = yandex_vpc_subnet.public[location.value].id
        }
      }
    }

    version   = var.k8s_version
    public_ip = true
  }
}

resource "yandex_kubernetes_node_group" "main" {
  cluster_id = yandex_kubernetes_cluster.main.id
  name       = local.k8s_node_group_name
  version    = var.k8s_version

  instance_template {
    platform_id = var.k8s_node_platform_id

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.public["a"].id]
      security_group_ids = [yandex_vpc_security_group.k8s.id]
    }

    resources {
      cores  = var.k8s_node_cores
      memory = var.k8s_node_memory
    }

    boot_disk {
      type = var.k8s_node_disk_type
      size = var.k8s_node_disk_size
    }

    scheduling_policy {
      preemptible = false
    }
  }

  scale_policy {
    auto_scale {
      min     = var.k8s_node_min
      max     = var.k8s_node_max
      initial = var.k8s_node_initial
    }
  }

  allocation_policy {
    location {
      zone = local.public_subnets["a"].zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }
}
