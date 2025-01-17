variable "aws_region" {
  description = "AWS region"
  type        = string
# Modify the following line and make sure you have the AWS region where your VPC is created
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID where EC2 will be created"
  type        = string
# Modify the following line and make sure you have the correct VPC ID 
  default     = "<Your VPC ID>"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
# Modify the following line and make sure you have the correct VPC CIDR block
  default     = "<Your VPC CIDR Block>"
}

variable "subnet_id" {
  description = "Subnet ID where EC2 willbe created"
  type        = string
# Modify the following line and make sure you have the correct subnet id where the EC2 should be created
  default     = "<Your Subnet ID>"
}

variable "project_id" {
  description = "Project ID"
  type        = string
# Uncomment the following line and make sure you have a valid name for your Project
#  default     = "<Your Project ID>"
}

variable "iam_policy_name" {
  description = "IAM Policy name"
  type        = string
# Uncomment the following line and make sure you have a valid name for your IAM Policy
#  default     = "<Your-IAM-policy-name>"
}

variable "ec2_ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
# Uncomment the following line and make sure you have a valid AMI instance ID
# For windows use the Windows AMI ID
#  default     = "ami-04e5276ebb8451442"
}

variable "ec2_security_group_name" {
  description = "EC2 Security Group Name"
  type        = string
# Uncomment the following line and make sure you have a valid name for your EC2 Security Group
#  default     = "<Your-EC2-SG-name>"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
# Uncomment the following line and make sure you have a valid Amazon instance type
#  default     = "t2.large"
}

variable "ec2_name" {
  description = "EC2 instance name"
  type        = string
# Uncomment the following line and make sure you have a valid name for your EC2
#  default     = "<Your-EC2-Instance-name>"
}

variable "ec2_role_name" {
  description = "EC2 Role name"
  type        = string
# Uncomment the following line and make sure you have a valid name for your EC2 Role
#  default     = "<Your-EC2-Role>"
}

variable "iam_instance_profile_name" {
  description = "IAM Instance Profile Name"
  type        = string
# Uncomment the following line and make sure you have a valid name for your IAM instance Profile
#  default     = "<Your-IAM-Instance-Profile-name>"
}

