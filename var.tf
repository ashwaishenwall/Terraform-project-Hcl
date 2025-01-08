variable "region" {
  description = "The AWS region to deploy resources in."
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/20"
}

variable "common_tags" {
  description = "Common tags for all resources."
  default = {
    Environment = "dev"
    Project     = "workflow"
  }
}
