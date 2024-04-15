# For Webservers
output "webserver_ids" {
  value = module.vms-staging.webservers_ids
}

output "webserver_private_ips" {
  value = module.vms-staging.webserver_private_ips
}


output "webserver_public_ips" {
  value = module.vms-staging.webserver_public_ips
}


output "instance_availability_zones" {
    value = module.vms-staging.webserver_availability_zones
}

# For private VMs
output "private_vm_ids" {
  value = module.vms-staging.private_vm_ids
}

output "private_vm_private_ips" {
  value = module.vms-staging.private_vm_private_ips
}


output "private_vm_availability_zones" {
    value = module.vms-staging.private_vm_availability_zones
}

output "autoscaling_group_name" {
    value = module.vms-staging.autoscaling_group_name
}

output "scaled_instances_ids" {
  value = module.vms-staging.scaled_instances_ids
}