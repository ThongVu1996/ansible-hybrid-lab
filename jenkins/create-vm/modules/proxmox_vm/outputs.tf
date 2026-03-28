output "vm_ips" {
  description = "Danh sách IPv4 của các Jenkins VM"
  value       = [for vm in proxmox_virtual_environment_vm.jenkins_node : vm.initialization[0].ip_config[0].ipv4[0].address]
}

output "tailscale_ssh_commands" {
  description = "Các lệnh SSH qua mạng Tailscale"
  value       = [for i in range(var.vm_instance_count) : "tailscale ssh ${var.user_name}@jenkins-lab-${i}"]
}
