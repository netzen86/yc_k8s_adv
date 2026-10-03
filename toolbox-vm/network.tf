resource "yandex_vpc_network" "k8s-adv-net" {
  name = "k8s-adv-net"
}

resource "yandex_vpc_subnet" "k8s-adv-subnet" {
  name           = "k8s-adv-subnet"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.k8s-adv-net.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}

resource "yandex_vpc_address" "addr" {
  name = "vm-adress"
  external_ipv4_address {
    zone_id = var.default_zone
  }
}