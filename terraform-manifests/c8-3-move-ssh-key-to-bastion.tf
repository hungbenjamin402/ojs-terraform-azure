# create a null resource and provisioners for ssh key
resource "null_resource" "null_move_ssh_key_to_bastion" {
  depends_on = [azurerm_linux_virtual_machine.bastion_host_linuxvm]
  #connection block used for provisioner to connect to bastion vm in azure
  connection {
    type = "ssh"
    host = azurerm_public_ip.bastion_public_ip.ip_address
    user = azurerm_linux_virtual_machine.bastion_host_linuxvm.admin_username
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
  }
  # file provisioner block used to copy ssh key (terraform.pem) to bastion vm (in /tmp/terraform-azure.pem)
  provisioner "file" {
    source = "ssh-keys/terraform-azure.pem"
    destination = "/tmp/terraform-azure.pem"
  }  
  #remote execution provisioner block used to change permissions of ssh key (terraform-azure.pem) on bastion vm
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/terraform-azure.pem"
    ]
  }
}