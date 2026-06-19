resource "yandex_mdb_mysql_cluster" "main" {
  name        = local.mysql_cluster_name
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.main.id
  version     = var.mysql_version

  deletion_protection = true

  resources {
    resource_preset_id = var.mysql_resource_preset_id
    disk_type_id       = var.mysql_disk_type_id
    disk_size          = var.mysql_disk_size
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  security_group_ids = [yandex_vpc_security_group.mysql.id]

  dynamic "host" {
    for_each = local.mysql_host_zones
    content {
      zone      = local.private_subnets[host.value].zone
      subnet_id = yandex_vpc_subnet.private[host.value].id
    }
  }
}

resource "yandex_mdb_mysql_database" "netology" {
  cluster_id = yandex_mdb_mysql_cluster.main.id
  name       = var.mysql_db_name
}

resource "yandex_mdb_mysql_user" "netology" {
  cluster_id = yandex_mdb_mysql_cluster.main.id
  name       = var.mysql_user
  password   = var.mysql_password

  permission {
    database_name = yandex_mdb_mysql_database.netology.name
    roles         = ["ALL"]
  }
}
