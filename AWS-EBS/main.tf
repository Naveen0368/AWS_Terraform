provider "aws" {
  region = "us-west-2" # Specify your AWS region
}

# Define an EBS volume
resource "aws_ebs_volume" "my_volume" {
  availability_zone = "us-west-2a" # Ensure this matches the AZ of your instance
  size              = 10           # Size in GB
  type              = "gp2"        # General Purpose SSD
  tags = {
    Name = "MyEBSVolume"
  }
}

# Attach the EBS volume to an existing EC2 instance
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh" # The device name exposed to the instance
  volume_id   = aws_ebs_volume.my_volume.id
  instance_id = "ami-0cf2b4e024cdb6960" # Replace with your instance ID
}
