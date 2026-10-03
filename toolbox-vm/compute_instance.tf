resource "yandex_compute_instance" "toolbox" {
  platform_id = "standard-v3"
  service_account_id = data.yandex_iam_service_account.terraform-sa.id
  name        = "yc-toolbox"
  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id      = yandex_vpc_subnet.k8s-adv-subnet.id
    nat            = true
    nat_ip_address = yandex_vpc_address.addr.external_ipv4_address[0].address
  }
  boot_disk {
    initialize_params {
      type     = "network-hdd"
      size     = "30"
      image_id = data.yandex_compute_image.toolbox.id
    }
  }
  metadata = {
    "ssh-keys" = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}