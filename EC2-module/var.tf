variable "ami_id" {
  default = "ami-02b8269d5e85954ef"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "devops"
}

variable "subnet_id" {
  default = "subnet-0a9bbec52e53e068b"
}

variable "security_group_ids" {
  type    = list(string)
  default = ["sg-07ec369293edce9a8"]
}

variable "instance_name" {
  default = "sagar"
}
