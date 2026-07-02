variable "name_prefix" {
  description = "Préfixe pour nommer les ressources (ex: inventra)"
  type        = string
}

variable "vpc_id" {
  description = "ID du VPC (sortie du module networking)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR autorisé à se connecter en SSH sur les EC2 (ex: 88.183.30.231/32)"
  type        = string
}
