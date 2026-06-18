locals {
  project = "netology"
  env     = "hw15-1"

  nat_instance_name = "${local.project}-${local.env}-nat"
  public_vm_name    = "${local.project}-${local.env}-public"
  private_vm_name   = "${local.project}-${local.env}-private"
  route_table_name  = "${local.project}-${local.env}-private-route"
  sg_nat_name       = "${local.project}-${local.env}-nat-sg"
  sg_public_name    = "${local.project}-${local.env}-public-sg"
  sg_private_name   = "${local.project}-${local.env}-private-sg"
}
