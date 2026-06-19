resource "yandex_vpc_security_group" "mysql" {
  name       = local.sg_mysql_name
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "mysql from vpc"
    v4_cidr_blocks = concat(var.public_cidr, [for subnet in local.private_subnets : subnet.cidr])
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
