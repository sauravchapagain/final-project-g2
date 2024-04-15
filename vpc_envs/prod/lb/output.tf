output "alb_dns_name" {
  description = "DNS Name"
  value       = module.prod_lb.alb_dns_name
}
