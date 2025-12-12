provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "my_ec2" {
  count         = 2
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  tags = {
    Name = "MyTerraformEC2"                        # this is server name
     env = var.env
 }
}

#-------------------------------------------------------------------------------------------------
# variable.tf
#-------------------------------------------------------------------------------------------------

variable "ami" {
  default = "ami-02b8269d5e85954ef"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "env" {
  default = "dev"
}

variable "key_name" {
 default = "devops"
}

#---------------------------------------------------------------------------------------------------
# outpute.tf
#---------------------------------------------------------------------------------------------------

output "public_ip" {
  value = aws_instance.my_ec2[*].public_ip
}

output "public_dns" {
  value = aws_instance.my_ec2[*].public_dns
}

output "private_ip" {
  value = aws_instance.my_ec2[*].private_ip
