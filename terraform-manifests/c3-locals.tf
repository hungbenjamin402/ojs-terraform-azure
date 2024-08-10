locals {
    environment = var.environment
    #resource_name_prefix = "${var.environment}"
    bastion_host = "${var.environment}-${var.bastion_vm}"
    common_tags = {
        environment = local.environment
    }
}