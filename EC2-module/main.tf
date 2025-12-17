# create root project folder
# mkdir project
# cd project

# create files
# touch main.tf variables.tf

# create module folders
# mkdir -p modules/ec2
# cd modules/ec2

# create module files
# touch main.tf variables.tf outputs.tf
#--------------------------------------------------------------------------------------------------------------------------
# inside the /project/modules/ec2
# vim main.tf

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type           = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_id

  tags = {
    Name = var.instance_name
  }
}
