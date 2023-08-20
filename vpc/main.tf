resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support

  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_subnet" "public" {
    for_each = local.public_subnets

    vpc_id = aws_vpc.vpc.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.name}-public-${each.key}"
    }
}

resource "aws_subnet" "private" {
    for_each = local.private_subnets

    vpc_id = aws_vpc.vpc.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az

    tags = {
      Name = "${var.name}-private-${each.key}"
    }
}

resource "aws_route_table" "internet-rt" {
    vpc_id = aws_vpc.vpc
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vpc-igw.id
    }

    tags = {
        Name = "${var.name}-internet-rt"
    }
}

resource "aws_route_table_association" "internet-rt"{
    for_each = aws_subnet.public

    subnet_id = each.value.id
    route_table_id = aws_route_table.internet-rt
}

