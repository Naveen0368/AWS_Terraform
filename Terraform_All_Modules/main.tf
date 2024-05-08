provider "aws" {
  region = "<region>"
}

data "aws_instance" "example" {
  instance_id = "<existing_instance_id>"
}

resource "aws_instance" "example" {
  ami           = data.aws_instance.example.ami
  instance_type = "<new_instance_type>"

  key_name               = data.aws_instance.example.key_name
  subnet_id              = data.aws_instance.example.subnet_id
  vpc_security_group_ids = data.aws_instance.example.vpc_security_group_ids

  root_block_device {
    volume_size = "<new_volume_size>"
    volume_type = data.aws_instance.example.root_block_device.volume_type
    delete_on_termination = data.aws_instance.example.root_block_device.delete_on_termination
  }

  ebs_block_device {
    device_name = data.aws_instance.example.ebs_block_device.*.device_name
    volume_size = data.aws_instance.example.ebs_block_device.*.volume_size
    volume_type = data.aws_instance.example.ebs_block_device.*.volume_type
    delete_on_termination = data.aws_instance.example.ebs_block_device.*.delete_on_termination
  }

  tags = data.aws_instance.example.tags
}
