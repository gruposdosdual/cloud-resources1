/*
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "eu-west-1a"
}
*/
/*
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
  default = "10.0.1.0/24"
}

variable "public_subnet_cidr_b" {
  default = "10.0.2.0/24"
}

variable "private_subnet_cidr_a" {
  default = "10.0.3.0/24"
}

variable "private_subnet_cidr_b" {
  default = "10.0.4.0/24"
}

variable "availability_zone_a" {
  default = "eu-west-1a"
}

variable "availability_zone_b" {
  default = "eu-west-1b"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}
*/

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
