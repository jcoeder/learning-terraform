provider "aws" {
    region = "us-east-2"
    access_key = "HA"
    secret_key = "HAHA"
}

variable "CentOS7-us-east-2" {
  type = string
  default = "ami-00f8e2c955f7ffa9b"
}

variable "CentOS8-us-east-2" {
  type = string
  default = "ami-0ac6967966621d983"
}

variable "Amazon-Linux-2-us-east-2" {
  type = string
  default = "ami-09246ddb00c7c4fef"
}



resource "aws_security_group" "allow_all" {
  name = "allow_all"
  description = "Allow All Traffic"
  vpc_id = aws_vpc.us-east-2-vpc-1.id

  ingress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Permit Any"
    from_port = 0
    ipv6_cidr_blocks = [ "::/0" ]
    prefix_list_ids = []
    protocol = "-1"
    security_groups = []
    self = false
    to_port = 0
  } ]

  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Permit Any"
    from_port = 0
    ipv6_cidr_blocks = [ "::/0" ]
    prefix_list_ids = []
    protocol = "-1"
    security_groups = []
    self = false
    to_port = 0
  } ]
}

# resource "aws_network_interface" "server-nic" {
#   subnet_id = aws_subnet.us-east-2-vpc-1-subnet-1.id
#   private_ips = [ "172.30.0.16" ]
#   security_groups = [ aws_security_group.allow_all.id ]
# }

# resource "aws_eip" "server-public" {
#   vpc = true
#   network_interface = aws_network_interface.server-nic.id
#   associate_with_private_ip = "172.30.0.16"
#   depends_on = [ aws_internet_gateway.us-east-2-vpc-1-igw-1 ]
# }

# resource "aws_instance" "Test" {
#     ami =  var.Amazon-Linux-2-us-east-2
#     instance_type = "t2.micro"
#     #subnet_id = aws_subnet.us-east-2-vpc-1-subnet-1.id
#     key_name = "Justin Oeder"
#     network_interface {
#       device_index = 0
#       network_interface_id = aws_network_interface.server-nic.id
#     }
#     tags = {
#         Name = "Test"
#     }
#     user_data = <<-EOF
# #!/bin/bash
# sudo yum install httpd -y
# sudo systemctl enable --now httpd
# EOF
# }

# output "server_public_ip" {
#   value = aws_eip.server-public.public_ip
# }