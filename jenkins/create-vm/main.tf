module "jenkins_vm" {
  source = "./modules/proxmox_vm"
  vm_instance_count       = var.vm_instance_count
  proxmox_template_name   = var.proxmox_template_name
  proxmox_node            = var.proxmox_node
  user_password           = var.user_password
  user_name               = var.user_name
  vm_ip_cidr              = var.vm_ip_cidr
  vm_gateway              = var.vm_gateway
  proxmox_ssh_private_key = var.proxmox_ssh_private_key
}
