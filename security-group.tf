provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "my_ec2" {                     # thise is block name 
  ami           = "ami-0c02fb55956c7d316"              # replace with your ami-id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.aws_sg.id]            # associating security group with instance
 
tags = {
    Name = "MyTerraformEC2"                                         # this is server name 
  }
}  

resource "aws_security_group" "aws_sg" {                           # to create security group
  name        = "sg_name"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = "vpc-0d31f38c0561ceb7a"

    ingress {                                       # inbound rule
    from_port   = 80  
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {                                       # outbound rule
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
  
    tags = {
    env = "dev"
  }
}




