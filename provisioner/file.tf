# scp -i devops.pem devops.pem ubuntu@13.126.53.63:/home/ubuntu
# ssh -i devops.pem ubuntu@13.126.53.63
# chmod 400 /home/ubuntu/devops.pem
# ls -l /home/ubuntu/devops.pem 
#--------------------------------------------------------------------------------------------------------------
# vim app.sh
# !/bin/bash
# sudo apt update -y
# sudo apt install apache2 -y
# sudo systemctl start apache2
# echo "<h1>File Provisioner Working</h1>" > /var/www/html/index.html
# chmod +x app.sh    # to give execute permission 
#-----------------------------------------------------------------------------------------------------------------
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "file_demo" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t3.micro"
  key_name      = "devops"

  # FILE PROVISIONER
  provisioner "file" {                 # Copies a file from:Local machine → Remote EC2 instance

    source      = "app.sh"
    destination = "/home/ubuntu/app.sh"
  }

  # REMOTE EXEC
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/app.sh",   # Make script executable
      "sudo /home/ubuntu/app.sh"        # Execute script with sudo
    ]
  }

  # CONNECTION BLOCK
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/ubuntu/devops.pem")
    host        = self.public_ip
  }

  tags = {
    Name = "file-provisioner"
  }
}
