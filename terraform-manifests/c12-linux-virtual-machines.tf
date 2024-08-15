# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "ojs_vm" {
  name                = "ojs-vm"
  resource_group_name = azurerm_resource_group.ojs_rg.name
  location            = azurerm_resource_group.ojs_rg.location
  
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  
  network_interface_ids = [azurerm_network_interface.ojs_nic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    echo "Updating package lists..."
    sudo apt-get update

    echo "Installing Apache, PHP, MySQL client, and Git..."
    sudo apt-get install -y apache2 php php-mysql mysql-client git

    echo "Installing PHP 8.1 and its extensions..."
    sudo apt install -y php8.1 php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath

    echo "Installing Composer..."
    sudo apt install -y composer

    echo "Installing npm..."
    sudo apt install -y npm

    echo "Installing Node.js stable version using n..."
    sudo npm install -g n
    sudo n stable

    echo "installing expect program for install script"
    sudo apt install expect -y

    echo "Changing directory to /var/www/html/..."
    cd /var/www/html/

    echo "Removing default index.html..."
    sudo rm index.html

    echo "Cloning the OJS repository..."
    sudo git clone https://github.com/pkp/ojs --recurse-submodules -b stable-3_4_0 /var/www/html

 
    echo "Installing dependencies for lib/pkp..."
    yes | sudo composer --working-dir=lib/pkp install

    echo "Installing dependencies for plugins/generic/citationStyleLanguage..."
    yes | sudo composer --working-dir=plugins/generic/citationStyleLanguage install

    echo "Installing dependencies for plugins/paymethod/paypal..."
    yes | sudo composer --working-dir=plugins/paymethod/paypal install

    echo "Running npm install..."
    sudo npm install

    echo "Building the project with npm..."
    sudo npm run build

    echo "Changing ownership of /var/www/html to the current user..."
    sudo chown -R $(whoami) /var/www/html

    #not sure if this used based on cloud-init-output.log
    echo "Copying the configuration template..."
    cp config.TEMPLATE.inc.php config.inc.php

    echo "connecting to database"
    export DB_HOSTNAME=${azurerm_mysql_flexible_server.ojs_server.fqdn}
    export DB_PORT=3306
    export DB_NAME=${azurerm_mysql_flexible_database.ojs_db.name}
    export DB_USERNAME=${azurerm_mysql_flexible_server.ojs_server.administrator_login}
    export DB_PASSWORD=${azurerm_mysql_flexible_server.ojs_server.administrator_password}
   
    echo "Setting ownership and permissions for cache directory..."
    sudo chown -R www-data:www-data /var/www/html/cache
    sudo chmod -R 755 /var/www/html/cache

    echo "Making upload files dir"
    mkdir /home/adminuser/ojs-file-uploads
    chmod 777 /home/adminuser/ojs-file-uploads
    chmod -R 777 /var/www/html/public
    chmod 777 /var/www/html/config.inc.php

    # install ojs with expect script
    expect <<'END_EXPECT'
    set script_path /var/www/html/tools/install.php
    #launch script
    spawn php $script_path
    expect "Select (en):"
    send -- "en\r"
    expect "Select (None):"
    send -- "\r"
    expect "Directory for uploads:"
    send -- "/home/adminuser/ojs-file-uploads\r"
    #admin account
    expect "Username:"
    send -- "${var.ojs_admin_user}\r"
    expect "Password:"
    send -- "${var.ojs_admin_password}\r"
    expect "Repeat password:"
    send -- "${var.ojs_admin_password}\r"
    expect "Email:"
    send -- "testojsemail@gmail.com\r"
    expect "Select:"
    send -- "mysqli\r"
    expect "Host (None):"
    send -- "${azurerm_mysql_flexible_server.ojs_server.fqdn}\r"
    expect "Username (None):"
    send -- "${azurerm_mysql_flexible_server.ojs_server.administrator_login}\r"
    expect "Password (None):"
    send -- "${azurerm_mysql_flexible_server.ojs_server.administrator_password}\r"
    expect "Database name:"
    send -- "${azurerm_mysql_flexible_database.ojs_db.name}\r"
    expect "Repository Identifier:"
    send -- "ojs2-test\r"
    expect "Provide a unique site ID and OAI base URL to PKP for statistics and security alert purposes only."
    send -- "Y\r"
    expect "*** Install Open Journal Systems"
    send -- "y\r"
    sleep 200
    expect eof
    END_EXPECT
    
    chmod 777 /var/www/html/config.inc.php
  
    ip_address="${azurerm_public_ip.web_lbpublicip.ip_address}"
    sudo sed -i "/allowed_hosts = \"/c\allowed_hosts = \"[\\\\\"$ip_address\\\\\"]\"" config.inc.php

    # again 
    echo "again, Setting ownership and permissions for cache directory..."
    sudo chown -R www-data:www-data /var/www/html/cache
    sudo chmod -R 755 /var/www/html/cache
    echo "Restarting Apache..."
    sudo systemctl restart apache2

    # touch /tmp/setup_complete
  EOF
  )
}

# resource "null_resource" "wait_for_setup" {
#   provisioner "remote-exec" {
#     inline = [
#       "while [ ! -f /tmp/setup_complete ]; do echo 'Waiting for setup to complete...'; sleep 10; done",
#       "echo 'Setup is complete.'"
#     ]

#     connection {
#       type        = "ssh"
#       user        = "adminuser"
#       private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
#       host        = azurerm_public_ip.ojs_public_ip.ip_address
#     }
#   }
#   depends_on = [azurerm_linux_virtual_machine.ojs_vm]
# }

#     sed -i 's/username = ojs/username = ${var.mysql_db_username}@${azurerm_mysql_flexible_server.ojs_db.name}/' config.inc.php