provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-02b8269d5e85954ef"          # change with your ami-id
  instance_type = "t3.micro"

  user_data = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
echo "<h1>Hello world</h1>" > /var/www/html/index.html
EOF

  tags = {
    Name = "heredoc"                            # server name 
  }
}
