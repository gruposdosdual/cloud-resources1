resource "aws_cloudwatch_log_group" "eks_logs" {
  name              = "/aws/eks/wordpress-cluster/cluster"
  retention_in_days = 30
}

/*
resource "aws_kms_alias" "this" {
  count      = var.create_kms_alias ? 1 : 0
  name       = "alias/eks/${var.cluster_name}"
  target_key_id = aws_kms_key.this.id
}
*/