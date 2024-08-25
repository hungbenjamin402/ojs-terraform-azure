# Terraform Configuration for Deploying Open Journal System (OJS) on Microsoft Azure

This repository contains Terraform configurations for deploying the Open Journal System (OJS) on Microsoft Azure. The configurations set up the necessary Azure resources, including virtual machines, load balancers, and databases, to host an OJS instance.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine
- Azure subscription and appropriate credentials
- SSH keys for secure access

## Getting Started

### 1. Initialize Terraform

Initialize the Terraform workspace to install necessary provider plugins.

```bash
terraform init
```

### 2. Plan the Deployment

Generate and review the execution plan for deploying the infrastructure.

```bash
terraform plan -var-file=secrets.tfvars
```

### 3. Apply the Configuration

Apply the Terraform configuration to create the necessary Azure resources.

```bash
terraform apply -var-file=secrets.tfvars -auto-approve
```

### 4. Destroy the Infrastructure

If needed, destroy the deployed infrastructure to avoid unnecessary costs.

```bash
terraform destroy -var-file=secrets.tfvars -auto-approve
```

## Post-Deployment Steps

### Verify OJS Page

1. Access the public IP address of the web load balancer, which can be found in the Terraform output or the Azure portal.
2. Use the following default credentials to log in to the OJS instance:

   - **Username**: `admin`
   - **Password**: `p@ssw0rd!$`

### Manual Changes

Be aware that any manual changes made to the OJS instance (e.g., creating a journal, adding content) are not tracked by Terraform state and may require manual cleanup in Azure if you decide to destroy the resources.

## Improvements and To-Do List

- **Update SSH Keys**: Ensure SSH keys are unique and secure.
- **Enhance Security**: Review and fix firewall rules and other security configurations.
- **Domains and DNS**: Set up domains and DNS configurations (note: this may incur additional costs).
- **SSL Certificates and HTTPS**: Implement SSL certificates and HTTP to HTTPS redirection.
- **Scaling and Load Balancing**: Consider implementing auto-scaling and further load balancing strategies.
- **DevOps Pipeline**: Integrate with a CI/CD pipeline for automated deployments.
- **Refactor Variables**: Clean up and organize Terraform variables for better readability and maintainability.
- **Terraform Modules**: Consider using Terraform modules for better modularity and reuse.
  
## Testing the OJS VM

To verify the installation and configuration of the OJS VM:

1. **Connect via SSH from Local Machine to Bastion Host:**

   ```bash
   ssh -i ssh-keys/terraform-azure.pem azureuser@<bastion_host_vm_public_ip>
   ```

2. **From the Bastion Host, Connect to the OJS VM:**

   ```bash
   sudo su -
   ssh -i /tmp/terraform-azure.pem adminuser@<ojs_vm_private_ip>
   ```

3. **Check Installation Logs:**

   ```bash
   tail -100f /var/log/cloud-init-output.log
   ```

## Database Access

To connect to the MySQL database:

```bash
mysql -h <db_server_host> -u dbadmin -p
```

Example:

```bash
mysql -h dev-mysql-server-khbduo.mysql.database.azure.com -u dbadmin -p
```

## SSH Warnings

If you encounter SSH warnings about inaccessible identity files or unknown hosts, update the known hosts:

```bash
ssh-keygen -f "/root/.ssh/known_hosts" -R "<ojs_vm_private_ip>"
```

## Team Environment Configuration

- **Remote Backend for State Management**: Configure a remote backend in Azure for team environments to manage Terraform state.
- **Lock Files for Production**: Use lock files in GitHub to prevent unintended changes to production infrastructure.

## Network Configuration

- **Load Balancer (LB)**: Used for public access to web VMs.
- **Inbound NAT Rules**: Configure NAT rules for admin access to web tier VMs.
- **Application Gateway**: Set up an Application Gateway for web subnet access.

## References

- Terraform modules and other dependencies are referenced in `.terraform/modules/modules.json`.
