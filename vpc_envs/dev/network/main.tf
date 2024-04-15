
# Retrieve global variables from the Terraform module
module "globalvars"{
  source = "../../../modules/globalvars"
}

# Define tags locally
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}

resource "aws_key_pair" "linux_key" {
  key_name   = "linux_key"
  public_key = file(var.path_to_linux_key)
    tags = merge({
    Name = "${local.name_prefix}-keypair"
    },
    local.default_tags
  )
}

# Module to deploy basic networking 
module "vpc-dev" {
  source = "../../../modules/aws_network"
  #source              = "git@github.com:igeiman/aws_network.git"
  env                = var.env
  vpc_cidr           = var.vpc_cidr
  public_cidr_blocks = var.public_subnet_cidrs
  private_cidr_block = var.private_subnet_cidrs
  prefix             = local.name_prefix
  default_tags       = local.default_tags
}
