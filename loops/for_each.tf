provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_ec2" {
  for_each = tomap({
    sagar-micro = "t3.micro"
    nehal-small = "t3.small"
  })

  ami           = var.ami
  instance_type = each.value
  key_name      = var.key_name

  tags = {
    Name = each.key
    env  = var.env
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
  value = [
for key in aws_instance.my_ec2 : key.public_ip
]
}

output "public_dns" {
  value = [
for key in aws_instance.my_ec2 : key.public_dns
]
}


output "private_ip" {
  value = [
for key in aws_instance.my_ec2 : key.private_ip
]
}
                                   
