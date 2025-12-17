# vim variable.tf


variable "username" {
  description = "RDS master username"
}

variable "password" {
  description = "RDS master password"
  sensitive   = true
}
