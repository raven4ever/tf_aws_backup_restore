resource "aws_efs_file_system" "efs" {
  creation_token = "efs_for_ec2s"

  tags = {
    name    = "efs_for_ec2s"
    project = "aws_backup_restore"
  }
}

resource "aws_efs_mount_target" "efs" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.subnet.id
  security_groups = [aws_security_group.mnt.id]
}
