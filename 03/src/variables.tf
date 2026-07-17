### cloud vars
variable "token" {
  type        = string
  description = "OAuth-token"
}

variable "cloud_id" {
  type        = string
  description = "Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Default zone"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "Default CIDR"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

### Task 2 vars
variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    { vm_name = "main", cpu = 2, ram = 2, disk_volume = 20 },
    { vm_name = "replica", cpu = 2, ram = 4, disk_volume = 30 }
  ]
  description = "Parameters for DB VMs"
}

variable "public_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to public SSH key"
}

variable "create_bastion" {
  type        = bool
  default     = true
  description = "Создавать ли бастион-сервер с внешним IP"
}

variable "run_ansible" {
  type        = bool
  default     = false
  description = "Запустить ansible-playbook после создания ресурсов"
}