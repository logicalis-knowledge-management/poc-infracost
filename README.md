# Proyecto Terraform: EC2 en Irlanda (eu-west-1)

Pequeño ejemplo que crea una instancia EC2 en la región de Irlanda con la talla configurable por variables.

## Requisitos
- Credenciales AWS configuradas (por ejemplo, con `aws configure`).
- Terraform >= 1.4, Provider AWS >= 5.0.

## Variables principales
- `aws_region` (string): región AWS. Por defecto `eu-west-1` (Irlanda).
- `instance_type` (string): tipo de instancia. Por defecto `t4g.nano` (económica ARM).
- `ami_arch` (string): `arm64` o `x86_64`. Debe concordar con la familia de CPU del `instance_type`.
  - Ejemplos: `t4g.*` => `arm64`, `t3.*`/`t2.*` => `x86_64`.
- `name` (string): nombre base para etiquetas. Por defecto `demo-ec2`.
- `key_name` (string | null): nombre de un Key Pair existente para SSH.
- `access_key` (string | null): Access Key ID opcional para el provider.
- `secret_key` (string | null): Secret Access Key opcional para el provider.

## Uso
```bash
cd terraform-ec2-eu-west-1
terraform init
terraform plan
terraform apply -auto-approve
```

Para cambiar la talla a `t3.micro` (x86_64):
```bash
terraform apply -var "instance_type=t3.micro" -var "ami_arch=x86_64"
```

Para especificar credenciales por variables (no recomendado en repos):
```bash
terraform apply \
  -var "access_key=AKIA..." \
  -var "secret_key=..."
```

Salidas (`outputs`): `instance_id`, `public_ip`, `public_dns`.

> Nota: Se usa la VPC y subred por defecto de la región. Si tu cuenta no tiene VPC por defecto, deberás suministrar tu propia VPC/Subred.
> Seguridad: Preferible usar perfiles (`aws_profile`) o variables de entorno (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) en vez de almacenar claves en archivos.
