# ─────────────────────────────────────────────────────────────────────
# module database — RDS PostgreSQL + stockage de l'URL de connexion
# ─────────────────────────────────────────────────────────────────────

resource "aws_db_instance" "main" {
  identifier     = "${var.name_prefix}-db"
  engine         = "postgres"
  engine_version = "15"

  instance_class    = var.db_instance_class
  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.sg_rds_id]

  multi_az                  = false
  backup_retention_period   = 1
  skip_final_snapshot       = true
  auto_minor_version_upgrade = true

  tags = {
    Name = "${var.name_prefix}-db"
  }
}

# ─── URL de connexion complete stockee en SecureString ──────────────
# Format : postgresql://username:password@endpoint:5432/dbname
# Jamais en clair dans un output Terraform - uniquement dans SSM,
# chiffre par la cle KMS par defaut du compte.
resource "aws_ssm_parameter" "db_url" {
  name        = "/${var.name_prefix}/db_url"
  description = "URL de connexion complete a la base RDS Inventra"
  type        = "SecureString"
  value       = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${var.db_name}"

  tags = {
    Name = "${var.name_prefix}-db-url"
  }
}
