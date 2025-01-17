terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Define provider and region
provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  region                   = var.aws_region
}

# Create a security group for the EC2 instance
resource "aws_security_group" "test_ec2_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Enter a proper security group name
  tags = {
    Name    = var.ec2_security_group_name
    project = var.project_id
  }
}

data "aws_iam_policy_document" "test_iam_policy" {
  statement {
    actions = ["s3:*",
    "s3-object-lambda:*"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions = ["ec2:*",
      "autoscaling:*",
      "cloudwatch:*",
      "eks:*",
      "cloudformation:*",
      "elasticloadbalancing:*"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions = ["ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssoications",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions = ["ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions = ["ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions = ["iam:*",
      "organizations:DescribeAccount",
      "organizations:DescribeOrganization",
      "organizations:DescribeOrganizationalUnit",
      "organizations:DescribePolicy",
      "organizations:ListChildren",
      "organizations:ListParents",
      "organizations:ListPoliciesForTarget",
      "organizations:ListRoots",
      "organizations:ListPolicies",
      "organizations:ListTargetsForPolicy"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "test_ec2_policy" {
  name        = var.iam_policy_name
  description = "Policies required for the bastion host to access other AWS resources "
  policy      = data.aws_iam_policy_document.test_iam_policy.json
}

resource "aws_iam_role" "test_ec2_role" {
# Enter a proper EC2 role name for this new role  - look at variables.tf
  name               = var.ec2_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name    = var.ec2_role_name
    project = var.project_id
  }
}

# Attach IAM policies to the role
resource "aws_iam_role_policy_attachment" "test_ec2_policy_attachment" {
  role       = aws_iam_role.test_ec2_role.name
  policy_arn = aws_iam_policy.test_ec2_policy.arn
}

# Create the IAM instance profile and associate the role
resource "aws_iam_instance_profile" "test_ec2_instance_profile" {
  name = var.iam_instance_profile_name
  role = aws_iam_role.test_ec2_role.name
}

resource "aws_instance" "test_ec2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.test_ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.test_ec2_instance_profile.name
  user_data              = <<EOF
# You can enter your commands that should be executed during the creation of this EC2
# !/bin/bash
# sudo yum update -y
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install
EOF

  tags = {
    Name    = var.ec2_name
    project = var.project_id
  }
}

