resource "aws_instance" "my_ec2" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t3.micro"
  key_name      = "devops"

  tags = {
    Name = "myserver"
  }
}
