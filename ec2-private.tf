provider "aws" {
  region = "us-east-1" # Replace with your preferred region
}

# Use an existing VPC
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["vpc-0a21a201105869ff2"] # Replace with your VPC name tag
  }
}

# Use an existing private subnet
data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet-0"] # Replace with your subnet name tag
  }
}

# Security Group for the EC2 Instance
resource "aws_security_group" "example" {
  name_prefix = "aws-sg-workflow"
  vpc_id      = data.aws_vpc.existing.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"] # Allow SSH within the VPC (adjust as needed)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws-private-instance-sg"
  }
}

# Reference the existing SSM Role
data "aws_iam_role" "existing_ssm_role" {
  name = "SSMInstanceProfile" # Replace with the name of your existing SSM role
}

# Instance Profile for the Existing SSM Role
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "SSMInstanceProfile"
  role = data.aws_iam_role.existing_ssm_role.name
}

# Launch EC2 Instance in Private Subnet
resource "aws_instance" "private_instance" {
  ami             = "ami-0df8c184d5f6ae949" # Replace with a valid AMI ID for your region
  instance_type   = "t2.xlarge"             # Adjust as needed
  subnet_id       = data.aws_subnet.private.id
  security_groups = [aws_security_group.example.name]

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  tags = {
    Name = "example-private-instance"
  }
}