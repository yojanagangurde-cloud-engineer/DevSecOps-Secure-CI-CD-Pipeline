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
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["71.236.247.47/32"]
  }

 egress {
  description = "Allow HTTPS outbound"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
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

  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [
    aws_security_group.flask_sg.id
  ]

  ebs_optimized = true
  monitoring  = true

  root_block_device {
    encrypted = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
    http_put_response_hop_limit = 2
  }
  tags = {
    Name = "DevSecOps-Flask-Server"
  }
}