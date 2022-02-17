resource "aws_vpc" "us-east-2-vpc-1" {
    cidr_block = "172.30.0.0/20"
    tags = {
        Name = "us-east-2-vpc-1"
    }
}

resource "aws_subnet" "us-east-2-vpc-1-subnet-1" {
    vpc_id = aws_vpc.us-east-2-vpc-1.id
    cidr_block = "172.30.0.0/24"
    tags = {
      "Name" = "us-east-2-vpc-1-subnet-1"
    }
  
}

resource "aws_internet_gateway" "us-east-2-vpc-1-igw-1" {
  vpc_id = aws_vpc.us-east-2-vpc-1.id
  tags = {
    "Name" = "us-east-2-vpc-1-igw-1"
  }
}

resource "aws_route_table" "us-east-2-vpc-1-igw-1-route" {
  vpc_id = aws_vpc.us-east-2-vpc-1.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.us-east-2-vpc-1-igw-1.id
  }
  route {
      ipv6_cidr_block = "::/0"
      gateway_id = aws_internet_gateway.us-east-2-vpc-1-igw-1.id
  }
  tags = {
    "Name" = "us-east-2-vpc-1-igw-1-route"
  }
}

resource "aws_route_table_association" "us-east-2-vpc-1-igw-1-route" {
  subnet_id = aws_subnet.us-east-2-vpc-1-subnet-1.id
  route_table_id = aws_route_table.us-east-2-vpc-1-igw-1-route.id
}