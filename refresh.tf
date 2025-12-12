provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "my_ec2" {                     # thise is block name
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t3.micro"

  tags = {
    Name = "MyTerraformEC2"                           # this is server name
  }
}
