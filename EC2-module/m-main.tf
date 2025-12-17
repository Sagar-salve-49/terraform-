# vim main.tf inside the /project
#---------------------------------------------------------------

provider "aws" {
  region = "ap-south-1"
}

module "ec2" {
  source = "./modules/ec2"

  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  subnet_id          = var.subnet_id
  security_group_ids = var.security_group_ids
  instance_name      = var.instance_name
}
