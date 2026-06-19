locals {
  project = "netology"
  env     = "hw15-4"

  mysql_cluster_name = "${local.project}-${local.env}-mysql"
  sg_mysql_name      = "${local.project}-${local.env}-mysql-sg"

  kms_key_name        = "${local.project}-${local.env}-k8s-key"
  k8s_cluster_name    = "${local.project}-${local.env}-k8s"
  k8s_node_group_name = "${local.project}-${local.env}-ng"
  k8s_cluster_sa_name = "${local.project}-${local.env}-k8s-cluster-sa"
  k8s_node_sa_name    = "${local.project}-${local.env}-k8s-node-sa"
  sg_k8s_name         = "${local.project}-${local.env}-k8s-sg"

  k8s_zones = ["a", "b", "d"]

  public_subnets = {
    a = {
      zone = "ru-central1-a"
      cidr = "10.10.10.0/24"
      name = "hw15-4-public-a"
    }
    b = {
      zone = "ru-central1-b"
      cidr = "10.10.11.0/24"
      name = "hw15-4-public-b"
    }
    d = {
      zone = "ru-central1-d"
      cidr = "10.10.12.0/24"
      name = "hw15-4-public-d"
    }
  }

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

  vpc_cidrs = concat(
    [for subnet in local.public_subnets : subnet.cidr],
    [for subnet in local.private_subnets : subnet.cidr]
  )
}
