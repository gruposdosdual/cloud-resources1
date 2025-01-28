variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr_a" {
  type        = string
  description = "CIDR block for the public subnet in AZ A"
}

variable "public_subnet_cidr_b" {
  type        = string
  description = "CIDR block for the public subnet in AZ B"
}

variable "private_subnet_cidr_a" {
  type        = string
  description = "CIDR block for the private subnet in AZ A"
}

variable "private_subnet_cidr_b" {
  type        = string
  description = "CIDR block for the private subnet in AZ B"
}

variable "availability_zone_a" {
  type        = string
  description = "Availability zone A"
}

variable "availability_zone_b" {
  type        = string
  description = "Availability zone B"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}
