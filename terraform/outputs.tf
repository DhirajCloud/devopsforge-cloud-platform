output "vpc_id" {
  description = "ID of the DevOpsForge VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnets
}

output "nat_gateway_public_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = module.vpc.nat_public_ips[0]
}

output "availability_zones" {
  description = "Availability Zones used by the VPC"
  value       = module.vpc.azs
}
