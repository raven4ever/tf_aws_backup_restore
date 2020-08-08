resource "aws_kms_key" "encrypt_key" {
  description = "KMS key 1"
}

resource "aws_backup_vault" "vault" {
  name        = "backup_vault"
  kms_key_arn = aws_kms_key.encrypt_key.arn
}

resource "aws_iam_role" "backup_role" {
  name               = "backup_role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attachpolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

