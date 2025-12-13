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

#---------------------------------------------------------------------------------------------------------
# variable.tf
#---------------------------------------------------------------------------------------------------------

variable "ami" {
  default = "ami-02b8269d5e85954ef"
}

variable "env" {
  default = "dev"
}

variable "key_name" {
 default = "devops"
}

#-----------------------------------------------------------------------------------------------------------------
# output.tf
#-----------------------------------------------------------------------------------------------------------------

output "public_ip" {
  value = [
    for inst in aws_instance.my_ec2 : inst.public_ip
  ]
}

output "private_ip" {
  value = [
    for inst in aws_instance.my_ec2 : inst.private_ip
  ]
}

output "public_dns" {
  value = [
    for inst in aws_instance.my_ec2 : inst.public_dns
  ]
}
