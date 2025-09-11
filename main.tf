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


resource "aws_db_subnet_group" "rds" {
  name       = "poc-infracost-rds-subnets"
  subnet_ids = data.aws_subnets.default.ids
}

resource "aws_security_group" "rds" {
  name        = "poc-infracost-rds-sg"
  description = "Allow DB access"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = length(var.allowed_cidrs) > 0 ? [1] : []
    content {
      description = "PostgreSQL"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidrs
    }
  }
}

resource "aws_db_instance" "rds" {
  identifier                 = "poc-infracost-rds"
  engine                     = "postgres"
  engine_version             = "15.5"
  instance_class             = var.db_instance_class
  db_name                    = var.db_name
  username                   = var.db_username
  password                   = random_password.db.result
  allocated_storage          = var.db_allocated_storage_gb
  storage_type               = "gp3"
  db_subnet_group_name       = aws_db_subnet_group.rds.name
  vpc_security_group_ids     = [aws_security_group.rds.id]
  multi_az                   = false
  publicly_accessible        = var.publicly_accessible
  backup_retention_period    = 1
  deletion_protection        = false
  skip_final_snapshot        = true
  apply_immediately          = true
  auto_minor_version_upgrade = true
  monitoring_interval        = 0
}
