output "public_ip" {
  description = "Public IP of the EC2 Web Server"
  value       = aws_instance.web.public_ip
}
