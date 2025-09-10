terraform {
  # Backend remoto en S3 para guardar el tfstate
  backend "s3" {
    # TODO: reemplaza con tu bucket existente
    bucket         = "logicalis-poc-infracost-tfstate"

    # Ruta dentro del bucket (puedes ajustarla por entorno/proyecto)
    key            = "poc-infracost/terraform.tfstate"

    # Región del bucket S3
    region         = "eu-west-1"

    # Tabla de DynamoDB para bloqueo de estados
    # Crea una tabla con clave de partición "LockID" (tipo String)
    dynamodb_table = "infracost-tfstate-locks"

    # Cifrar el estado en reposo
    encrypt        = true
  }
}

