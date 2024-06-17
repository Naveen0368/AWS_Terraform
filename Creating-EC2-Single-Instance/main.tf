provider "aws" {
  region = "us-west-2"  # Specify the AWS region you want to use
}

resource "aws_instance" "example" {
  ami           = "ami-0cf2b4e024cdb6960"  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"              # Instance type

  tags = {
    Name = "example-instance"
  }
}