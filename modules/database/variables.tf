variable "name_prefix" {
  description = "Prefixe pour nommer les ressources (ex: inventra)"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Nom du DB subnet group (sortie du module networking)"
  type        = string
}

variable "sg_rds_id" {
  description = "ID du security group RDS (sortie du module security)"
  type        = string
}

variable "db_name" {
  description = "Nom de la base de donnees PostgreSQL"
  type        = string
}

variable "db_username" {
  description = "Nom d'utilisateur PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Mot de passe PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Classe d'instance RDS"
  type        = string
}
