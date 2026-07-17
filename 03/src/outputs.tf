locals {
  # Объединяем все ВМ в один список для итерации
  all_vms = concat(
    yandex_compute_instance.web_vms,
    [for k, v in yandex_compute_instance.db_vms : v],
    [yandex_compute_instance.storage]
  )
}

output "vm_list_info" {
  description = "Список словарей с информацией о всех ВМ (Задание 5*)"
  value = [
    for vm in local.all_vms : {
      name = vm.name
      id   = vm.id
      fqdn = vm.fqdn
    }
  ]
}