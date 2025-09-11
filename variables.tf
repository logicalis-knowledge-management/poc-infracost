variable "aws_region" {
  description = "Región AWS para desplegar (Irlanda = eu-west-1)"
  type        = string
  default     = "eu-west-1"
}

variable "ami_arch" {
  description = "Arquitectura de la AMI a usar: arm64 o x86_64. Cambia a x86_64 si usas una instancia no-ARM (por ej. t3.micro)."
  type        = string
  default     = "arm64"
  validation {
    condition     = contains(["arm64", "x86_64"], lower(var.ami_arch))
    error_message = "ami_arch debe ser 'arm64' o 'x86_64'."
  }
}

variable "name" {
  description = "Nombre base para etiquetar la instancia."
  type        = string
  default     = "demo-ec2"
}

variable "key_name" {
  description = "Nombre del Key Pair existente para SSH (opcional)."
  type        = string
  default     = null
}

variable "access_key" {
  description = "AWS Access Key ID a usar (opcional)."
  type        = string
  default     = null
}

variable "secret_key" {
  description = "AWS Secret Access Key a usar (opcional)."
  type        = string
  default     = null
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type = string
  default = "admin"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage_gb" {
  type    = number
  default = 20
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "allowed_cidrs" {
  type    = list(string)
  default = []
}
