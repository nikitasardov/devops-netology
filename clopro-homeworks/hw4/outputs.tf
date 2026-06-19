output "network" {
  value = {
    vpc_id            = yandex_vpc_network.main.id
    public_subnet_id  = yandex_vpc_subnet.public.id
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
