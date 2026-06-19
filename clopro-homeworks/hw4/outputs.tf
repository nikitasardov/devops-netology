output "network" {
  value = {
    vpc_id            = yandex_vpc_network.main.id
    public_subnet_id  = { for key, subnet in yandex_vpc_subnet.public : key => subnet.id }
    private_subnet_id = { for key, subnet in yandex_vpc_subnet.private : key => subnet.id }
  }
}

output "mysql" {
  value = {
    cluster_id   = yandex_mdb_mysql_cluster.main.id
    cluster_name = yandex_mdb_mysql_cluster.main.name
    hosts        = yandex_mdb_mysql_cluster.main.host
    database     = yandex_mdb_mysql_database.netology.name
    user         = yandex_mdb_mysql_user.netology.name
  }
}

output "kms" {
  value = {
    key_id   = yandex_kms_symmetric_key.k8s.id
    key_name = yandex_kms_symmetric_key.k8s.name
  }
}

output "kubernetes" {
  value = {
    cluster_id   = yandex_kubernetes_cluster.main.id
    cluster_name = yandex_kubernetes_cluster.main.name
    node_group   = yandex_kubernetes_node_group.main.name
    external_v4  = yandex_kubernetes_cluster.main.master[0].external_v4_address
    internal_v4  = yandex_kubernetes_cluster.main.master[0].internal_v4_address
  }
}
