provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "my_ec2" {                     # thise is block name 
  ami           = "ami-0c02fb55956c7d316"   
  instance_type = "t3.micro"

  tags = {
    Name = "MyTerraformEC2"                           # this is server name 
  }
}
