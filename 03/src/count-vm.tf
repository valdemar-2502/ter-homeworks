resource "yandex_compute_instance" "web_vms" {
  count = 2

  # Задание 2.3: Создаются после ВМ из for_each-vm.tf
  depends_on = [yandex_compute_instance.db_vms]

  name        = "web-${count.index + 1}" # web-1 и web-2 (не web-0 и web-1)
  hostname    = "web-${count.index + 1}"
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
    ssh-keys = "ubuntu:${local.public_key}" # Задание 2.4
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = false
  }

  allow_stopping_for_update = true
}