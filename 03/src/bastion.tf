resource "yandex_compute_instance" "bastion" {
  count = var.create_bastion ? 1 : 0

  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${local.public_key}"
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true # У бастиона ВНЕШНИЙ IP
  }

  allow_stopping_for_update = true
}