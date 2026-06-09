output "public_ip" {
  description = "Public IP of EC2"
  value       = aws_instance.flask_server.public_ip
}

output "public_dns" {
  description = "Public DNS of EC2"
  value       = aws_instance.flask_server.public_dns
}