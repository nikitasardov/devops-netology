locals {
  project = "netology"
  env     = "hw15-4"

  mysql_cluster_name = "${local.project}-${local.env}-mysql"
  sg_mysql_name      = "${local.project}-${local.env}-mysql-sg"

  private_subnets = {
    a = {
      zone = "ru-central1-a"
      cidr = "10.10.20.0/24"
      name = "hw15-4-private-a"
    }
    b = {
      zone = "ru-central1-b"
      cidr = "10.10.21.0/24"
      name = "hw15-4-private-b"
    }
    d = {
      zone = "ru-central1-d"
      cidr = "10.10.22.0/24"
      name = "hw15-4-private-d"
    }
  }

  mysql_host_zones = ["a", "b"]
}
