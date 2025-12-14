terraform {
 backend  "s3" {
 bucket = "sagar-vihirgaon-bhaubucket-1111"             # your s3 bucket name 
 key    = "terraform.tfstate"                           # file name inside s3 bucket
 region = "ap-south-1"                                  # Region of S3 bucket

 }
}

#------------------------------------------------------------------------------------------------------
# ec2.tf
#------------------------------------------------------------------------------------------------------

provider "aws" {
 region = "ap-south-1"
}

resource "aws_instance" "my_instance" {
 ami = "ami-02b8269d5e85954ef"
 instance_type = "t3.micro"

   tags = {
    Name = "terraform"
     env = "prod"
 }
}
