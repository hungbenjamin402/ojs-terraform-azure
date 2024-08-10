# Virtual Network, 4 subnets and their NSGs

# Virtual network
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default = "vnet-default"
}
variable "vnet_address_space" {
    description = "Address space of virtual network"
    type = list(string)
    default = ["10.0.0.0/16"]
}

# web subnet name + address 
variable "web_subnet_name" {
    description = "Name of the web subnet in virtual network"
    type = string
    default = "web-subnet"
}
variable "web_subnet_address" {
    description = "Web subnet IP and subnet mask"
    type = list(string)
    default = ["10.0.1.0/24"]
}

# app subnet name + address
variable "app_subnet_name" {
    description = "Name of the app subnet in virtual network"
    type = string
    default = "app-subnet"
}
variable "app_subnet_address" {
    description = "Web subnet IP and subnet mask"
    type = list(string)
    default = ["10.0.11.0/24"]
}

# db subnet name + address
variable "db_subnet_name" {
    description = "Name of the database subnet in virtual network"
    type = string
    default = "db-subnet"
}
variable "db_subnet_address" {
    description = "database subnet IP and subnet mask"
    type = list(string)
    default = ["10.0.100.0/24"]
}

# bastion subnet name + address
variable "bastion_subnet_name" {
    description = "Name of the bastion subnet in virtual network"
    type = string
    default = "bastionsubnet"
}

variable "bastion_subnet_address" {
    description = "bastion subnet IP and subnet mask"
    type = list(string)
    default = ["10.1.100.0/24"]
}