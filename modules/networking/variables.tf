variable "name_prefix" {
  description = "Préfixe pour nommer les ressources (ex: inventra)"
  type        = string
}

variable "vpc_cidr" {
  description = "Plage CIDR du VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDRs des sous-réseaux publics (frontend + backend)"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs des sous-réseaux privés (RDS)"
  type        = list(string)
}

variable "availability_zones" {
  description = "Liste des AZ à utiliser (une par subnet, doit couvrir au moins 2 AZ différentes)"
  type        = list(string)
}
