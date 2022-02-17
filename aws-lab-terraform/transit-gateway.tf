resource "aws_ec2_transit_gateway" "us-east-2-tgw-1" {
  description = "us-east-2-tgw-1"
  tags = {
    Name = "us-east-2-tgw-1"
  }
  amazon_side_asn = 65001
}

resource "aws_ec2_transit_gateway_vpc_attachment" "us-east-2-tgw-1-vpc-1-subnet-1" {
  transit_gateway_id = aws_ec2_transit_gateway.us-east-2-tgw-1.id
  vpc_id = aws_vpc.us-east-2-vpc-1.id
  subnet_ids = [aws_subnet.us-east-2-vpc-1-subnet-1.id]
}