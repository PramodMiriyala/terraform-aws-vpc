resource "aws_vpc" "base" {
  cidr_block           = var.vpc_config.cidr_block
  enable_dns_hostnames = var.vpc_config.enable_dns_hostnames
  tags                 = var.vpc_config.tags
}
resource "aws_subnet" "public" {
  count             = length(var.public_subn)
  availability_zone = var.public_subn[count.index].availability_zone
  vpc_id            = aws_vpc.base.id
  cidr_block        = var.public_subn[count.index].cidr_block
  tags              = var.public_subn[count.index].tags
  depends_on        = [aws_vpc.base]
}
resource "aws_subnet" "private" {
  count             = length(var.private_subn)
  availability_zone = var.private_subn[count.index].availability_zone
  vpc_id            = aws_vpc.base.id
  cidr_block        = var.private_subn[count.index].cidr_block
  tags              = var.private_subn[count.index].tags
  depends_on        = [aws_vpc.base]
}

resource "aws_internet_gateway" "igw" {
  count  = local.are_there_any_public_subnets ? 1 : 0
  vpc_id = aws_vpc.base.id
  tags = {
    Name = "base_igw"
  }
  depends_on = [aws_subnet.public]
}

resource "aws_route_table" "public" {
  count  = local.are_there_any_public_subnets ? 1 : 0
  vpc_id = aws_vpc.base.id
  tags = {
    Name = "public"
  }
  depends_on = [aws_subnet.public, aws_internet_gateway.igw]
}
resource "aws_route" "internet" {
  count                  = local.are_there_any_public_subnets ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = local.anywhere
  gateway_id             = aws_internet_gateway.igw[0].id
}
resource "aws_route_table" "private" {
  count  = local.are_there_any_private_subnets ? 1 : 0
  vpc_id = aws_vpc.base.id
  tags = {
    Name = "private"
  }
  depends_on = [aws_subnet.private]
}
resource "aws_route_table_association" "public" {
  count          = length(var.public_subn)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
  depends_on     = [aws_subnet.public, aws_internet_gateway.igw, aws_route_table.public]
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subn)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
  depends_on     = [aws_subnet.private, aws_route_table.private]
}
