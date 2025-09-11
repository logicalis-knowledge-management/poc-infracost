provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# VPC por defecto en la región seleccionada
data "aws_vpc" "default" {
  default = true
}

# Subred por defecto (una de las AZ) dentro de la VPC por defecto
data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# AMIs de Amazon Linux 2023 para ambas arquitecturas
data "aws_ami" "al2023_arm64" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*arm64*"]
  }
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "al2023_x86_64" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*x86_64*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  selected_ami_id = lower(var.ami_arch) == "arm64" ? data.aws_ami.al2023_arm64.id : data.aws_ami.al2023_x86_64.id
  subnet_id       = length(data.aws_subnets.default.ids) > 0 ? data.aws_subnets.default.ids[0] : null
  tags_common = {
    Name        = var.name
    Project     = "terraform-ec2-demo"
    Provisioner = "Terraform"
  }
  instance_type = "t4g.nano"
}

resource "aws_instance" "this" {
  ami           = local.selected_ami_id
  instance_type = local.instance_type

  subnet_id                   = local.subnet_id
  associate_public_ip_address = false

  key_name = var.key_name

  tags = local.tags_common
}
