# mkdir project
# cd project/
# vim  main.tf , vim variable.tf , vim terraform.tfvars
# mkdir rds
# cd rds/
# vim main.tf , vim variable.tf
#---------------------------------------------------------------------------------------------------------
# inside rds/
# vim main.tf
#---------------------------------------------------------------------------------------------------------

################################
# Default VPC & Subnets
################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

################################
# RDS Security Group
################################
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
################################
# DB Subnet Group
################################
resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
}

################################
# RDS Instance
################################
resource "aws_db_instance" "my_rds" {
  identifier             = "my-rds-db"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "mydb"
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "my-rds-db"
  }
}
