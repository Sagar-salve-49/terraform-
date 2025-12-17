# cd ..
# inside the project
#----------------------------------------------------------------------------------------
# vim main.tf
#----------------------------------------------------------------------------------------

provider "aws" {
  region = "ap-south-1"
}

module "db" {
  source = "./rds"

  username = var.username
  password = var.password
}
