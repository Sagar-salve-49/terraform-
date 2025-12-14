provider "aws" {
    region = "ap-south-1"
  }

  resource "aws_instance" "my_server" {                # thise is block name 
    ami = "var.ami"                                    # replace with your ami-id
    instance_type = "var.instance_type"
    key_name = "var.key_name"
    vpc_security_group_ids = [aws_security_group.my_sg.id]    # associating security group with instance
 

    tags = {
    Name = "sec_server"                              # this is server name 
    }
}

resource "aws_security_group" "my_sg" {               # to create security group
 name = "aws_sg"
 description = "allow ssh and http"
 vpc_id = "vpc-044a04ca9bbfa20d0"


 ingress {                                         # inbound rule
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

 egress  {
    from_port = "0"                               # outbound rule
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

 }

 tags = {
    env = "dev"
 }
  
}


 
