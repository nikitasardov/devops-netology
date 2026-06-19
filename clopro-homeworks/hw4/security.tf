resource "yandex_vpc_security_group" "mysql" {
  name       = local.sg_mysql_name
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "mysql from vpc"
    v4_cidr_blocks = local.vpc_cidrs
    port           = 3306
  }

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "k8s" {
  name       = local.sg_k8s_name
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol          = "TCP"
    description       = "k8s health checks"
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol       = "TCP"
    description    = "nodeport for load balancer"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }

  ingress {
    protocol       = "ANY"
    description    = "internal vpc traffic"
    v4_cidr_blocks = local.vpc_cidrs
    from_port      = 0
    to_port        = 65535
  }

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
