# ─────────────────────────────────────────────────────────────────────
# module security — Security Groups + IAM (moindre privilège)
# ─────────────────────────────────────────────────────────────────────

# ─── SG frontend : HTTP/HTTPS public + SSH restreint ───────────────
resource "aws_security_group" "frontend" {
  name        = "${var.name_prefix}-sg-frontend"
  description = "Autorise HTTP/HTTPS public et SSH restreint"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP public"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS public"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH administration"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Tout le trafic sortant (yum/pip/npm, appels API AWS...)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg-frontend"
  }
}

# ─── SG backend : API interne uniquement depuis le frontend ────────
resource "aws_security_group" "backend" {
  name        = "${var.name_prefix}-sg-backend"
  description = "Autorise le port 5000 uniquement depuis le SG frontend, SSH restreint"
  vpc_id      = var.vpc_id

  ingress {
    description     = "API Flask uniquement depuis le frontend"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  ingress {
    description = "SSH administration"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Tout le trafic sortant (pip, appels SSM, connexion RDS...)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg-backend"
  }
}

# ─── SG rds : jamais public, uniquement depuis le backend ──────────
resource "aws_security_group" "rds" {
  name        = "${var.name_prefix}-sg-rds"
  description = "Autorise le port 5432 uniquement depuis le SG backend aucun acces public"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL uniquement depuis le backend"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  # Pas d'egress déclaré volontairement : RDS n'initie pas de connexions
  # sortantes, donc pas besoin d'ouvrir de trafic sortant sur ce SG.

  tags = {
    Name = "${var.name_prefix}-sg-rds"
  }
}

# ─── IAM role EC2 : lecture SSM Parameter Store + Secrets Manager ──
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2" {
  name               = "${var.name_prefix}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "${var.name_prefix}-ec2-role"
  }
}

data "aws_iam_policy_document" "ec2_read_secrets" {
  statement {
    sid = "ReadSSMParameters"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]
    resources = ["arn:aws:ssm:*:*:parameter/${var.name_prefix}/*"]
  }

  statement {
    sid       = "DecryptSSMSecureString"
    actions   = ["kms:Decrypt"]
    resources = ["*"]
  }

  statement {
    sid       = "ReadSecretsManager"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:*:*:secret:${var.name_prefix}/*"]
  }
}

resource "aws_iam_role_policy" "ec2_read_secrets" {
  name   = "${var.name_prefix}-ec2-read-secrets"
  role   = aws_iam_role.ec2.id
  policy = data.aws_iam_policy_document.ec2_read_secrets.json
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.name_prefix}-ec2-instance-profile"
  role = aws_iam_role.ec2.name
}
