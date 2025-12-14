output "public_ip" {
value = aws_instance.my_server.public_ip
}

output "private_ip" {
value = aws_instance.my_server.private_ip
}

output "public_dns" {
value = aws_instance.my_server.public_dns
  
}
