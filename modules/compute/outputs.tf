
output "all_server_dns" {
  value = aws_instance.web-server[*].public_dns
}