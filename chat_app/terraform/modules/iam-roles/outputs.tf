# terraform/modules/iam-roles/outputs.tf
output "cluster_role_arn" {
  value = aws_iam_role.cluster_role.arn
}

output "node_role_arn" {
  value = aws_iam_role.node_role.arn
}








/*
output "role_arn" {
  value = aws_iam_role.this.arn
}
*/