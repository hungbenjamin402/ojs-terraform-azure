# SSH keys

Generate your own key pair here before running Terraform (these files are git-ignored):

    ssh-keygen -t rsa -b 4096 -f terraform-azure -N ""
    mv terraform-azure terraform-azure.pem
