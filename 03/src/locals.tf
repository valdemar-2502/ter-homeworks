locals {
  # Считываем публичный ключ для использования в metadata
  public_key = file(var.public_key_path)
}