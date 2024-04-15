# Module to deploy basic networking 
module "vms-prod" {
  source = "../../../modules/aws_webservers"
  #source             = "github.com/Dhansca/acsnwmodule.git"
  prefix        = var.prefix
  instance_type = "t3.medium"
  default_tags  = var.default_tags

  #  default_tags       = var.default_tags
}