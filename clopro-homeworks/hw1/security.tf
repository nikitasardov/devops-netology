resource "yandex_vpc_security_group" "nat" {
  name       = local.sg_nat_name
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "ANY"
    description    = "traffic from private subnet"
    v4_cidr_blocks = var.private_cidr
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

resource "yandex_vpc_security_group" "public" {
  name       = local.sg_public_name
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "ICMP"
    description    = "icmp"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "private" {
  name       = local.sg_private_name
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "ssh from public subnet"
    v4_cidr_blocks = var.public_cidr
    port           = 22
  }

  ingress {
    protocol       = "ICMP"
    description    = "icmp from public subnet"
    v4_cidr_blocks = var.public_cidr
  }

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
