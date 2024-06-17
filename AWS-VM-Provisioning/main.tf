provider "aws" {
  region = "us-west-2"
}

# Create a VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Devops_test"
  }
}

# Create a subnet
resource "aws_subnet" "custom_subnet" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "my_devops_Subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "custom_igw"
  }
}

# Create a route table
resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }

  tags = {
    Name = "Devops_test_route_table"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "custom_route_table_association" {
  subnet_id      = aws_subnet.custom_subnet.id
  route_table_id = aws_route_table.custom_route_table.id
}

# Create a security group
resource "aws_security_group" "custom_security_group" {
  vpc_id = aws_vpc.custom_vpc.id

  ingress {
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
    Name = "Devops_test_security_group"
  }
}

# Create an EC2 instance
resource "aws_instance" "ubuntu_instance" {
  ami                    = "ami-0cf2b4e024cdb6960" # Ubuntu Server 20.04 LTS AMI (replace with your desired AMI ID)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.custom_subnet.id
  vpc_security_group_ids = [aws_security_group.custom_security_group.id]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              # Update the system
              apt-get update -y
              apt-get upgrade -y

              # Enable password authentication
              sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
              sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
              systemctl restart sshd

              # Set the password for ubuntu user
              echo "ubuntu:YourPasswordHere" | chpasswd

              # Ensure the ubuntu user can use sudo without a password
              echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
              EOF

  tags = {
    Name = "terraform-ubuntu-instance"
  }
}

output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}

output "subnet_id" {
  value = aws_subnet.custom_subnet.id
}

output "instance_id" {
  value = aws_instance.ubuntu_instance.id
}

output "public_ip" {
  value = aws_instance.ubuntu_instance.public_ip
}
