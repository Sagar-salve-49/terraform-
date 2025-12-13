provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "local" {
  ami           = "ami-02b8269d5e85954ef"       # local-exec
  instance_type = "t3.small"

  provisioner "local-exec" {
    command = "echo EC2 Created with ID: ${self.id} >> ec2.txt"               
  }

  tags = {
    Name = "local-exec-ec2"
  }
}
