# vim output.tf  inside the /project/modules/ec2
#-------------------------------------------------------------------------------

output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}

