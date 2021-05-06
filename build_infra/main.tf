
terraform {
  required_version = ">= 0.14.9"
}

provider "aws" {
  region = var.region
}

# Security group to allow ping to the EC2 instance
resource "aws_security_group" "r_allow_icmp" {
  name        = "r-ICMP"
  description = "Allow ICMP traffic Only"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.ingress_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "r-ICMP"
	Owner = "Vijay Manral"
	Purpose = "testing"
  }
}

# Security group to allow SSH to the EC2 instance
resource "aws_security_group" "r_allow_ssh" {
  name        = "r-SSH"
  description = "Allow SSH traffic Only"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "r-SSH"
	Owner = "Vijay Manral"
	Purpose = "testing"
  }
}

# Security group to allow http to the EC2 instance
resource "aws_security_group" "r_allow_http" {
  name        = "r-HTTP"
  description = "Allow HTTP traffic Only"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr, var.ingress_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "r-HTTP"
	Owner = "Vijay Manral"
	Purpose = "testing"
  }
}

# Create network interfaces for the EC2's
resource "aws_network_interface" "r_network_interface" {
	count         	= var.instance_count
	subnet_id 		= var.subnet_private_id_A
	security_groups = [aws_security_group.r_allow_icmp.id, aws_security_group.r_allow_ssh.id, aws_security_group.r_allow_http.id]
	tags = {
		Name = "r_machine_interface-${count.index + 1}"
	}
}

# Create Ubuntu 18.04 EC2 instances with Python pre-installed (required for Ansible)
resource "aws_instance" "r_machine" {
  count         = var.instance_count
  ami           = var.aws_ami
  instance_type = var.aws_instance_type
  key_name		= var.key_pair
  user_data     = <<EOF
#! /bin/bash
apt-get update
apt-get install -y python
apt-get install -y python-pip
  EOF

  network_interface {
    network_interface_id = aws_network_interface.r_network_interface[count.index].id
    device_index         = 0
  }

  tags = {
    Name = "r-Instance-${count.index + 1}"
	Owner = "Vijay Manral"
	Purpose = "To run web server"
  }
}

# Create an elastic load balancer
resource "aws_elb" "r_elb" {
  name               = "r-elb"
  internal           = true
  security_groups    = [aws_security_group.r_allow_http.id]
  subnets            = [var.subnet_private_id_A, var.subnet_private_id_B]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = "${tolist("${aws_instance.r_machine.*.id}")}"
  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "r_elb"
  }
}

