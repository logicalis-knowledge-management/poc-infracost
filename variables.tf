variable "aws_region" {
  description = "Región AWS para desplegar (Irlanda = eu-west-1)"
  type        = string
  default     = "eu-west-1"
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
