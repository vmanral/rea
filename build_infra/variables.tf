# The AWS region under which the web server resources would be created
variable "region" {
  default = "us-west-2"
}

# The number of EC2 instances to be launched for the web server. This is for load balancing purpose
variable "instance_count" {
  default = 2
}

# The AWS VPC
variable "vpc_id" {
  default = "vpc-ef25358b"
}

# The cidr range to cover the IP's of the end user machines to access the web application 
variable "ingress_cidr" {
  default = "10.0.0.0/8"
}

# The cidr range to cover the IP of the ELB to access the web application running on the EC2's 
variable "ingress_vpc_cidr" {
  default = "172.0.0.0/8"
}

# The EC2 Key pair to enable making a SSH connection to the web servers 
variable "key_pair" {
  default = "aws_devops"
}

# The Ubuntu 18.04 ami image in the us-west-2 region
variable "aws_ami" {
  default = "ami-090717c950a5c34d3"
}

# The class of the EC2 instance
variable "aws_instance_type" {
  default = "t2.micro"
}

# The VPC subnet to be used by the EC2 network interfaces and the ELB
variable "subnet_private_id_A" {
  default = "subnet-d5a2f1a3"
}

# The VPC subnet to be used by the ELB. This is dummy in our case as the EC2 instances are launched in the previous subnet 
variable "subnet_private_id_B" {
  default = "subnet-15e7df71"
}
