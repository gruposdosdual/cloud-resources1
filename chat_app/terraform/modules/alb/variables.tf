variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "security_groups" {
  description = "Security groups to attach to the ALB"
  type        = list(string)
}

variable "subnets" {
  description = "Subnets for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
