    provider "aws" {
  region = "us-west-2"  # Specify the AWS region you want to use
}

resource "aws_instance" "example" {
  count         = 3  # Number of instances to create
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"              # Instance type

  tags = {
    Name = "example-instance-${count.index}"
  }
}