output "bastion_host_vm_pip" {
    description = "Public IP address of the bastion host VM"
    value = azurerm_public_ip.bastion_public_ip.ip_address
}