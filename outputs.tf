output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "IP pública de la instancia"
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "DNS público de la instancia"
  value       = aws_instance.this.public_dns
}

