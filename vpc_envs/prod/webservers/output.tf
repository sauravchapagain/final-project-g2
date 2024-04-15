# For Webservers
output "webserver_ids" {
  value = module.vms-prod.webservers_ids
}

output "webserver_private_ips" {
  value = module.vms-prod.webserver_private_ips
}


output "webserver_public_ips" {
  value = module.vms-prod.webserver_public_ips
}


output "instance_availability_zones" {
    value = module.vms-prod.webserver_availability_zones
}

# For private VMs
output "private_vm_ids" {
  value = module.vms-prod.private_vm_ids
}

output "private_vm_private_ips" {
  value = module.vms-prod.private_vm_private_ips
}


output "private_vm_availability_zones" {
    value = module.vms-prod.private_vm_availability_zones
}

output "autoscaling_group_name" {
    value = module.vms-prod.autoscaling_group_name
}

output "scaled_instances_ids" {
  value = module.vms-prod.scaled_instances_ids
}