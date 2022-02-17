resource "aws_customer_gateway" "main" {
  bgp_asn    = 65000
  ip_address = "98.29.217.6"
  type       = "ipsec.1"

  tags = {
    Name = "main-customer-gateway"
  }
}