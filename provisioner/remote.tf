# scp -i devops.pem devops.pem ubuntu@13.126.53.63:/home/ubuntu
# ssh -i devops.pem ubuntu@13.126.53.63
# chmod 400 /home/ubuntu/devops.pem
# ls -l /home/ubuntu/devops.pem 

provider "aws" {
  region = "ap-south-1"

}

resource "aws_instance" "remote" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t3.micro"
  key_name      = "devops"                     # Attaches an AWS key pair to the EC2 instance
                                               # Used later for SSH access 
  provisioner "remote-exec" {                  
    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y",
      "sudo systemctl start apache2"
    ]
  }

  connection {                      # Terraform uses this block to decide how to connect to EC2
    type        = "ssh"             # Linux server → SSH connection
    user        = "ubuntu"
    private_key =  file("/home/ubuntu/devops.pem")   # Reads the private key from Terraform host machine
    host        = self.public_ip                     # self refers to the current resource (aws_instance.remote)
  }

  tags = {
    Name = "remote-exec-ec2"
  }
}



# scp -i devops.pem devops.pem ubuntu@13.126.53.63:/home/ubuntu
# ssh -i devops.pem ubuntu@13.126.53.63
# chmod 400 /home/ubuntu/devops.pem
# ls -l /home/ubuntu/devops.pem 

