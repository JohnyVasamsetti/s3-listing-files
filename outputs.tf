output "instance_static_ip" {
  description = "Static Ip to access the api"
  value       = aws_eip.this.public_ip
}
