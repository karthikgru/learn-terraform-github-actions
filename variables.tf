variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
    default = "guru-eks-${random_string.suffix.result}"
}