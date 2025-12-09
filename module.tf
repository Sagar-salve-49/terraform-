# modules/vpc/vpc.tf
#-------------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block                                                   # mkdir project
                                                                                     # cd project

  tags = {
    Name = "${var.project}-vpc"                                                      # mkdir -p modules/vpc
  }                                                                               
}

resource "aws_subnet" "pub_subnet" {
  cidr_block              = var.vpc_cidr_pub_subnet
  vpc_id                  = aws_vpc.my_vpc.id
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-pub-subnet"
  }
}

resource "aws_subnet" "pri_subnet" {
  cidr_block        = var.vpc_cidr_pri_subnet
  vpc_id            = aws_vpc.my_vpc.id
  availability_zone = "ap-south-1a"

  tags = {
    Name = "${var.project}-pri-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.project}-igw"
  }
}

resource "aws_default_route_table" "my_rt" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#-----------------------------------------------------------------------------------------------------------
# modules/vpc/variables.tf
#-----------------------------------------------------------------------------------------------------------

variable "project" {}
variable "vpc_cidr_block" {}
variable "vpc_cidr_pub_subnet" {}
variable "vpc_cidr_pri_subnet" {}

#-----------------------------------------------------------------------------------------------------------
# modules/vpc/outputs.tf
#-----------------------------------------------------------------------------------------------------------

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.pub_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.pri_subnet.id
}

#-------------------------------------------------------------------------------------------------------------------
# cd ~/project
#-------------------------------------------------------------------------------------------------------------------
# module.tf

provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source                = "./modules/vpc"
  project               = var.project
  vpc_cidr_block        = var.vpc_cidr_block
  vpc_cidr_pub_subnet   = var.vpc_cidr_pub_subnet
  vpc_cidr_pri_subnet   = var.vpc_cidr_pri_subnet
}

#-------------------------------------------------------------------------------------------------------------------
# variable.tf
#-------------------------------------------------------------------------------------------------------------------

variable "project" {
  default = "cdec45"
}

variable "vpc_cidr_block" {
  default = "172.16.0.0/16"
}

variable "vpc_cidr_pub_subnet" {
  default = "172.16.0.0/20"
}

variable "vpc_cidr_pri_subnet" {
  default = "172.16.16.0/20"
}


#---------------------------------------------------------------------------------------------------------------------
# output.tf
#---------------------------------------------------------------------------------------------------------------------

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet" {
  value = module.vpc.public_subnet_id
}

output "private_subnet" {
  value = module.vpc.private_subnet_id
}





