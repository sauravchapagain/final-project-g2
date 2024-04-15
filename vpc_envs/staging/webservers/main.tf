# Module to deploy basic networking 
module "vms-staging" {
  source = "../../../modules/aws_webservers"
  #source             = "github.com/Dhansca/acsnwmodule.git"
  prefix        = var.prefix
  instance_type = "t3.small"
  default_tags  = var.default_tags

  #  default_tags       = var.default_tags
}