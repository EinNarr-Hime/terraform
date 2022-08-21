# VPCの設定
resource "aws_vpc" "sample" {
  cidr_block                       = var.vpc_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false
  tags                             = local.sample_tags
}

# ルートテーブルの作成
resource "aws_route_table" "sample" {
  vpc_id = aws_vpc.sample.id
  tags   = local.sample_tags
}

# サブネットの設定
resource "aws_subnet" "sample" {
  vpc_id            = aws_vpc.sample.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.subnet_az
  tags              = local.sample_tags
}

# ルートテーブルとサブネットの紐付け
resource "aws_route_table_association" "sample" {
  route_table_id = aws_route_table.sample.id
  subnet_id      = aws_subnet.sample.id
}

# インターネットゲートウェイの設定
resource "aws_internet_gateway" "sample" {
  vpc_id = aws_vpc.sample.id
  tags   = local.sample_tags
}

# ルート設定
resource "aws_route" "sample" {
  route_table_id         = aws_route_table.sample.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sample.id
  depends_on             = [aws_route_table.sample]
}

# ネットワークACLの設定
resource "aws_default_network_acl" "sample" {
  default_network_acl_id = aws_vpc.sample.default_network_acl_id
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = local.sample_tags
}
