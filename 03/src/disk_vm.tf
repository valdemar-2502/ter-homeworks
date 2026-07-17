# 3.1: 3 одинаковых диска по 1 Гб с помощью count
resource "yandex_compute_disk" "storage_disks" {
  count = 3
  name  = "storage-disk-${count.index + 1}"
  size  = 1
  zone  = var.default_zone
  type  = "network-hdd"
}

# 3.2: Одиночная ВМ (без count/for_each)
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  hostname    = "storage"
  platform_id = "standard-v1"

  resources {
    cores         = 2
    memory        = 2
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
    nat                = false
  }

  # 3.3: Динамическое подключение дисков через for_each
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disks
    content {
      disk_id = secondary_disk.value.id
    }
  }

  allow_stopping_for_update = true
}