provider "aws" {
  region = "us-east-1" # Replace with your preferred region
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "example-vpc"
  }
}

# Create an Internet Gateway (required for public subnets, but we won't use it here)
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "example-internet-gateway"
  }
}

# Create a Route Table (without default route to Internet)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "example-private-route-table"
  }
}

# Create a Private Subnet
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "example-private-subnet"
  }
}

# Associate the Private Subnet with the Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Security Group for the EC2 Instance
resource "aws_security_group" "example" {
  name_prefix = "example-sg-"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allow SSH within the VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 Instance in the Private Subnet
resource "aws_instance" "private_instance" {
  ami           = "ami-12345678" # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"     # Adjust instance type as needed
  subnet_id     = aws_subnet.private.id
  security_groups = [aws_security_group.example.name]

  tags = {
    Name = "example-private-instance"
  }
}
