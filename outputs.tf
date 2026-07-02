#######################################
# Compute
#######################################

output "frontend_public_ip" {
  description = "IP publique du frontend"
  value       = module.compute.frontend_public_ip
}

output "backend_private_ip" {
  description = "IP privée du backend"
  value       = module.compute.backend_private_ip
}

output "frontend_url" {
  description = "URL de l'application"
  value       = module.compute.frontend_url
}

output "backend_instance_id" {
  description = "ID de l'instance backend"
  value       = module.compute.backend_instance_id
}

output "frontend_instance_id" {
  description = "ID de l'instance frontend"
  value       = module.compute.frontend_instance_id
}

#######################################
# Database
#######################################

output "db_endpoint" {
  description = "Endpoint de la base RDS"
  value       = module.database.db_endpoint
}

output "db_port" {
  description = "Port PostgreSQL"
  value       = module.database.db_port
}

output "db_name" {
  description = "Nom de la base"
  value       = module.database.db_name
}

output "db_identifier" {
  description = "Identifiant RDS"
  value       = module.database.db_identifier
}

output "db_connection_ssm_path" {
  description = "Chemin du paramètre SSM"
  value       = module.database.db_connection_ssm_path
}

#######################################
# Networking
#######################################

output "vpc_id" {
  description = "ID du VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Subnets publics"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Subnets privés"
  value       = module.networking.private_subnet_ids
}

output "db_subnet_group_name" {
  description = "DB subnet group"
  value       = module.networking.db_subnet_group_name
}

#######################################
# Security
#######################################

output "sg_frontend_id" {
  description = "Security Group Frontend"
  value       = module.security.sg_frontend_id
}

output "sg_backend_id" {
  description = "Security Group Backend"
  value       = module.security.sg_backend_id
}

output "sg_rds_id" {
  description = "Security Group RDS"
  value       = module.security.sg_rds_id
}

output "ec2_instance_profile_name" {
  description = "Instance Profile EC2"
  value       = module.security.ec2_instance_profile_name
}