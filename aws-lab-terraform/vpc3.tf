resource "aws_vpc" "us-east-2-vpc-3" {
    cidr_block = "172.30.32.0/20"
    tags = {
        Name = "us-east-2-vpc-3"
    }
}

resource "aws_subnet" "us-east-2-vpc-3-subnet-1" {
    vpc_id = aws_vpc.us-east-2-vpc-3.id
    cidr_block = "172.30.32.0/24"
    tags = {
      "Name" = "us-east-2-vpc-3-subnet-1"
    }
  
}

resource "aws_internet_gateway" "us-east-2-vpc-3-igw-1" {
  vpc_id = aws_vpc.us-east-2-vpc-3.id
  tags = {
    "Name" = "us-east-2-vpc-3-igw-1"
  }
}

resource "aws_route_table" "us-east-2-vpc-3-igw-1-route" {
  vpc_id = aws_vpc.us-east-2-vpc-3.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.us-east-2-vpc-3-igw-1.id
  }
  route {
      ipv6_cidr_block = "::/0"
      gateway_id = aws_internet_gateway.us-east-2-vpc-3-igw-1.id
  }
  tags = {
    "Name" = "us-east-2-vpc-3-igw-1-route"
  }
}

resource "aws_route_table_association" "us-east-2-vpc-3-igw-1-route" {
  subnet_id = aws_subnet.us-east-2-vpc-3-subnet-1.id
  route_table_id = aws_route_table.us-east-2-vpc-3-igw-1-route.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "us-east-2-tgw-1-vpc-3-subnet-1" {
  transit_gateway_id = aws_ec2_transit_gateway.us-east-2-tgw-1.id
  vpc_id = aws_vpc.us-east-2-vpc-3.id
  subnet_ids = [aws_subnet.us-east-2-vpc-3-subnet-1.id]
}