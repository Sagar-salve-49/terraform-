# mkdir project
# cd project/


provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "my_ec2" {                     # thise is block name
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  tags = {
    Name = "MyTerraformEC2"                        # this is server name
     env = var.env
 }
}
