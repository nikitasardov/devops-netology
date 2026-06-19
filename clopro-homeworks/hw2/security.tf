resource "yandex_vpc_security_group" "lamp" {
  name       = local.sg_lamp_name
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = var.public_cidr
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "http from internet via nlb"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    description       = "instance group and nlb health checks"
    protocol          = "TCP"
    port              = 80
    predefined_target = "loadbalancer_healthchecks"
  }

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
