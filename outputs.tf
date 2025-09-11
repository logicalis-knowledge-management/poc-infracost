output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.this.id
}

output "rds_endpoint" {
  value = aws_db_instance.rds.address
}

output "rds_port" {
  value = aws_db_instance.rds.port
}

output "rds_db_name" {
  value = aws_db_instance.rds.db_name
}

