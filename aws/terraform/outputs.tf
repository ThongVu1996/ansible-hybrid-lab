output "ec2_public_ip" {
  description = "Public IP of the EC2 Web Server"
  value       = module.web_server.public_ip
}

output "ansible_run_command" {
  description = "Command to run ansible playbook"
  value       = "ansible-playbook -i ../ansible/inventory.ini ../ansible/playbook.yml"
}
