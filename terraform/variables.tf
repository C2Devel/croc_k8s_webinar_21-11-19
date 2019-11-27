variable "region" {
  default = ""
}

## Cluster Specification
variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = ""
}

variable "kubernetes_ami" {
  description = "Ami for kubernetes cluster"
  default     = ""
}

variable "masters_count" {
  description = "The count of Master nodes in the Kubernetes cluster"
  default     = ""
}

variable "nodes_count" {
  description = "The count of Worker nodes in the Kubernetes cluster"
  default     = ""
}

variable "bootstrap_token" {
  description = "Token for bootstrap connections for kubernetes nodes"
  default     = ""
}

## Network Specification
variable "vpc_cidr" {
  description = "The CIDR Range for the Kubernetes cluster vpc"
  default     = ""
}

variable "private_subnet_cidr_list" {
  description = "The CIDR list of the Kubernetes nodes will be placed in"
  default     = []
}
