variable "region" {
  default = "us-west-2"
}

variable "instance_count" {
  default = 2
}

variable "vpc_id" {
  default = "vpc-ef25358b"
}

variable "ingress_cidr" {
  default = "10.0.0.0/8"
}

variable "ingress_vpc_cidr" {
  default = "172.0.0.0/8"
}

variable "key_pair" {
  default = "aws_devops"
}

# this is the Ubuntu 18.04 ami image
variable "aws_ami" {
  default = "ami-090717c950a5c34d3"
}

variable "aws_instance_type" {
  default = "t2.micro"
}

variable "subnet_private_id_A" {
  default = "subnet-d5a2f1a3"
}

variable "subnet_private_id_B" {
  default = "subnet-15e7df71"
}
