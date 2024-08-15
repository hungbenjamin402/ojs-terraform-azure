## terraform init, plan, approve
### terraform plan -var-file=secrets.tfvars
### terraform apply -var-file=secrets.tfvars -auto-approve
### terraform destroy -var-file=secrets.tfvars -auto-approve


## test ojs page works
### go to the public ip addy of web load balancer from outputs or on azure
### user: admin
### password: p@ssw0rd!$
### if you create journal or add do stuff manually it is not tracked by the state so might have to delete/destroy manually in azure

## other stuff to implement
### update ssh keys so diff than ones used in course
### fix firewall rules and other security stuff
### domains/dns stuff -> might cost money
### ssl cert and https redirect (only with autoscaling/ag? not sure)
### scaling and app gateway?
### clean up variables
### more lb stuff?
### dev ops pipeline?
### terraform modules?

# test ojs vm #
## from local machine
### ssh -i ssh-keys/terraform-azure.pem azureuser@<bastion_host_vm_pip from output>
## once logged into bastion vm
### sudo su -
### ssh -i /tmp/terraform-azure.pem adminsuser@<private ip of ojs vm on azure>
## once logged into adminuser (ojsvm)
### tail -100f /var/log/cloud-init-output.log 

# ssh
### for ojs vm use adminuser
### for bastion use azureuser

## verify ojs vm by ssh into bastion then ssh into ojs vm
### from local machine
### ssh -i <path to key> azureuser@<bastionip>
### from bastion vm
### ssh -i /tmp/terraform-azure adminuser@<web-lb-pip>
### look at /var/log/cloud-init-output.log and verify installation (use cat, tail, etc)


## connect to db
###  mysql -h <host/server> -u dbadmin -p
###  mysql -h dev-mysql-server-khbduo.mysql.database.azure.com -u dbadmin -p

## ssh warning from bastion to ojs vm
### Warning: Identity file terraform-azure.pem not accessible: No such file or directory.
###  ssh-keygen -f "/root/.ssh/known_hosts" -R "10.1.1.4"



### FOR TEAM ENV when deployed
## add remote backend to azure for team environment
## add lock file to github for production -> important when infrastructure deployed and stays deployed
##   if no lock file present then terraform downloads latest versions for constraints in required_providers
## LB used for public access to web vms
## LB inbound nat rules used for admin to have direct access to web tier vms (need nat rules? not sure)
## application gateway used for access to web subnet
## references to modules that are not local will be in .terraform/modules/modules.json
