provider "aws" {
  region = var.region
}

# Get default VPC

data "aws_vpc" "default" {
  default = true
}

# Security Group

resource "aws_security_group" "flask_sg" {
  name        = "flask-security-group"
  description = "Allow Flask and SSH"

  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "Flask App"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevSecOps-SecurityGroup"
  }
}

# Latest Amazon Linux 2023

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# EC2 Instance

resource "aws_instance" "flask_server" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [
    aws_security_group.flask_sg.id
  ]

  tags = {
    Name = "DevSecOps-Flask-Server"
  }
}