provider "aws" {
  region = "us-east-1" # Replace with your preferred AWS region
}

# Use an existing VPC
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["your-vpc-name"] # Replace with your VPC name tag
  }
}

# Use an existing private subnet
data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["your-private-subnet-name"] # Replace with your subnet name tag
  }
}

# Security Group for the EC2 Instance
resource "aws_security_group" "example" {
  name_prefix = "example-sg-"
  vpc_id      = data.aws_vpc.existing.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allow SSH within the VPC (adjust as needed)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-private-instance-sg"
  }
}

# Reference the existing SSM Role
data "aws_iam_role" "existing_ssm_role" {
  name = "your-existing-ssm-role-name" # Replace with the name of your existing SSM role
}

# Instance Profile for the Existing SSM Role
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "example-ssm-instance-profile"
  role = data.aws_iam_role.existing_ssm_role.name
}

# Launch EC2 Instance in Private Subnet
resource "aws_instance" "private_instance" {
  ami           = "ami-12345678" # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"     # Adjust as needed
  subnet_id     = data.aws_subnet.private.id
  security_groups = [aws_security_group.example.name]

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  tags = {
    Name = "example-private-instance"
  }
}
