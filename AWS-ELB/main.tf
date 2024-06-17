# Main Terraform script to create an ELB

provider "aws" {
  region = "us-west-2"
}

# Define the security group for the ELB
resource "aws_security_group" "elb_sg" {
  name        = "elb_sg"
  description = "Security group for the ELB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the Elastic Load Balancer
resource "aws_elb" "web_elb" {
  name               = "web-elb"
  availability_zones = ["us-west-2a", "us-west-2b"]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  security_groups = [aws_security_group.elb_sg.id]

  tags = {
    Name = "web-elb"
  }
}

# Output the DNS name of the ELB
output "elb_dns_name" {
  value = aws_elb.web_elb.dns_name
}
