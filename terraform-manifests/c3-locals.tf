locals {
    environment = var.environment
    #resource_name_prefix = "${var.environment}"

    common_tags = {
        environment = local.environment
    }
}