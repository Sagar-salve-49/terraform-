Terraform

terraform opensource IAC code
Multicloud {aws, GCP , AZURE ,}
Reusable infra
Blocks
{
}
Block types

provider
resource
data
variable
output
module
terraform
terraform HCL Harshicorp langg ## terraform langg

yaml -- indentation specific - space

terraform --
syntax:

key = value

       ami= ami_id


provider

provider  "aws" {
 
region = "us-west-2"
}
resource ""
data types:

number = 131244
string = "abhilash"
eg ami = "ami_id"

list = ["sg-1", "sg-2", "sg-3"]
map = sg-1

 sts.yaml  | k8s


.tf | .tf.json

to install terraform

1: role - instance / aws cli configure -- access key | secret key
2: terraform install on ubuntu/linux/windows/ wsl ubuntu
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform


Terraform AWS Practical Examples 🚀

This repository contains multiple Terraform practical examples for AWS, covering EC2, loops, variables, outputs, user_data (heredoc), S3 bucket, tfvars, and remote backend (S3).

It is useful for DevOps beginners, interview preparation, and hands-on practice.


📌 Prerequisites

Before using this repo, make sure you have:

AWS Account

IAM User with required permissions

AWS CLI configured

aws configure


Terraform installed

terraform -v

🔹 1. EC2 Creation using for_each Loop

Creates multiple EC2 instances using a map.

Example
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


✅ Use Case

Creating multiple servers with different instance types

Avoids duplicate code

🔹 2. Simple EC2 Instance (ec2.tf)

Creates one EC2 instance.

resource "aws_instance" "my_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"

  tags = {
    Name = "MyTerraformEC2"
  }
}

🔹 3. EC2 with User Data (Heredoc)

Installs Nginx automatically when EC2 launches.

user_data = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
echo "<h1>Hello world</h1>" > /var/www/html/index.html
EOF


✅ Use Case

Bootstrapping servers

Installing packages automatically

🔹 4. EC2 with Security Group + Outputs
Security Group
resource "aws_security_group" "aws_sg" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

Outputs
output "public_ip" {
  value = aws_instance.my_ec2.public_ip
}


✅ Outputs show:

Public IP

Public DNS

Private IP

🔹 5. S3 Bucket + File Upload

Creates an S3 bucket and uploads a file.

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraform-sagar-bucket-1234567"
}

resource "aws_s3_object" "file_upload" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "myfile.txt"
  source = "${path.module}/myfile.txt"
}


⚠️ Bucket name must be globally unique.

🔹 6. Terraform Variables & tfvars
variables.tf
variable "ami" {}
variable "instance_type" {}
variable "env" {}

terraform.tfvars
ami           = "ami-02b8269d5e85954ef"
instance_type = "t3.micro"
env           = "dev"


✅ Best practice for managing environments (dev/test/prod).

🔹 7. Remote Backend (tfstate in S3)

Stores Terraform state file securely in S3.

terraform {
  backend "s3" {
    bucket = "sagar-vihirgaon-bhaubucket-1111"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}


✅ Benefits

Team collaboration

State file security

No local state loss

▶️ How to Run
terraform init
terraform plan
terraform apply


To destroy resources:

terraform destroy
