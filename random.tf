resource "random_password" "db" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?" # Evita "/", '"' y "@" no permitidos por RDS
}

