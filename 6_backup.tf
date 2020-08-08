resource "aws_backup_plan" "backup" {
  name = "backup_plan"

  rule {
    rule_name         = "backup_rule"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = "cron(0 12 * * ? *)"
    start_window      = 120
    completion_window = 360

    lifecycle {
      cold_storage_after = 0
      delete_after       = 90
    }

    copy_action {
      destination_vault_arn = aws_backup_vault.vault.arn

      lifecycle {
        cold_storage_after = 0
        delete_after       = 90
      }
    }
  }

  tags = {
    name    = "backup"
    project = "aws_backup_restore"
  }
}

resource "aws_backup_selection" "bk_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "backup_selection"
  plan_id      = aws_backup_plan.backup.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "project"
    value = "aws_backup_restore"
  }
}
