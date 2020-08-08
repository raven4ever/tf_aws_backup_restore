resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name    = "allow_web_rule"
    project = "aws_backup_restore"
  }
}

resource "aws_security_group" "ec2" {
  name        = "ec2_nfs_sg"
  description = "Allow traffic out to NFS for mnt."
  vpc_id      = aws_vpc.vpc.id

  tags = {
    name    = "ec2_nfs_sg"
    project = "aws_backup_restore"
  }
}

resource "aws_security_group" "mnt" {
  name        = "mnt_sg"
  description = "Allow traffic from instances using web_server_instance."
  vpc_id      = aws_vpc.vpc.id

  tags = {
    name    = "mnt_sg"
    project = "aws_backup_restore"
  }
}

resource "aws_security_group_rule" "nfs-out" {
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2.id
  source_security_group_id = aws_security_group.mnt.id
}

resource "aws_security_group_rule" "nfs-in" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.mnt.id
  source_security_group_id = aws_security_group.ec2.id
}

