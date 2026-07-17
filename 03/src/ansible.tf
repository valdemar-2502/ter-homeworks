locals {
  # Приводим все ресурсы к списку для единообразной передачи в шаблон
  webservers_list = yandex_compute_instance.web_vms
  databases_map   = yandex_compute_instance.db_vms
  storage_list    = [yandex_compute_instance.storage]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = local.webservers_list
    databases  = local.databases_map
    storage    = local.storage_list
  })
  filename = "${abspath(path.module)}/inventory.ini"
}