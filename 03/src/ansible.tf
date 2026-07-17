locals {
  webservers_list = yandex_compute_instance.web_vms
  databases_map   = yandex_compute_instance.db_vms
  storage_list    = [yandex_compute_instance.storage]
  bastion_list    = yandex_compute_instance.bastion # <-- Убрали лишние скобки!
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tftpl", {
    webservers = local.webservers_list
    databases  = local.databases_map
    storage    = local.storage_list
    bastion    = local.bastion_list
  })
  filename = "${abspath(path.module)}/inventory.ini"
}

resource "terraform_data" "ansible_provision" {
  count = var.run_ansible ? 1 : 0

  depends_on = [
    yandex_compute_instance.bastion,
    yandex_compute_instance.web_vms,
    yandex_compute_instance.db_vms,
    yandex_compute_instance.storage,
    local_file.ansible_inventory
  ]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${abspath(path.module)}/inventory.ini ${abspath(path.module)}/test.yml"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  triggers_replace = {
    inventory_hash = md5(local_file.ansible_inventory.content)
  }
}