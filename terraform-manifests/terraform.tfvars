environment = "dev"
resource_group_name = "ojs_rg"
resource_group_location = "westus"
vnet_name = "vnet"
vnet_address_space = ["10.1.0.0/16"]

web_subnet_name = "web-subnet"
web_subnet_address = ["10.1.1.0/24"]

app_subnet_name = "app-subnet"
app_subnet_address = [ "10.1.11.0/24"]

db_subnet_name = "db-subnet"
db_subnet_address = ["10.1.21.0/24"]

bastion_subnet_name = "bastion-subnet"
bastion_subnet_address = ["10.1.100.0/24"]
bastion_vm = "bastion-host-linuxvm"

ojs_admin_user = "admin"