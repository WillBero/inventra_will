output "db_endpoint" {
  description = "Endpoint (hostname) de l'instance RDS"
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "Port de l'instance RDS"
  value       = aws_db_instance.main.port
}

output "db_name" {
  description = "Nom de la base de donnees"
  value       = aws_db_instance.main.db_name
}

output "db_identifier" {
  description = "Identifiant de l'instance RDS (utilisé par le module monitoring)"
  value       = aws_db_instance.main.identifier
}


output "db_connection_ssm_path" {
  description = "Path du parametre SSM contenant l'URL de connexion (pas le mot de passe)"
  value       = aws_ssm_parameter.db_url.name
}
