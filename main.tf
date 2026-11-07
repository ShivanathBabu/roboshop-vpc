resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = "true"

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-VPC"
        }
    )
}

resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-Ig"
    }
  )
}

resource "aws_subnet" "public" {
count = length(var.Public_subnet)
cidr_block = var.Public_subnet[count.index]
availability_zone = local.az
vpc_id = aws_vpc.vpc.id
map_public_ip_on_launch = true

tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-public-subnet"
    }
  )
  
}

resource "aws_subnet" "private" {
count = length(var.Private_subnet)
cidr_block = var.Private_subnet[count.index]
availability_zone = local.az
vpc_id =  aws_vpc.vpc.id
tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-private-subnet"
    }
  )
}

resource "aws_subnet" "database" {
count = length(var.database_subnet)
cidr_block = var.database_subnet[count.index]
availability_zone = local.az
vpc_id = aws_vpc.vpc.id  
tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-database-subnet"
    }
  )
}

resource "aws_elastic_ip" "eip" {
    domain = "vpc"
    tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-eip"
    }
  )

}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_elastic_ip.id
  subnet_id = aws_subnet.public[0].id

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-nat"
    }
  )

}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
   tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-public_route"
    }
  )
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-private_route"
    }
  )
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-database_route"
    }
  )
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.name.id
}

resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route" "database_route" {
  route_table_id = aws_route_table.database_route_table.id
   destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public_association"{
    count = length(var.Public_subnet)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public_route_table.id

}

resource "aws_route_table_association" "private_association" {
    count = length(var.Private_subnet)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private_route_table.id

}

resource "aws_route_table_association" "database_association" {
    count = length(var.database_subnet)
    subnet_id = aws_subnet.database[count.index].id
    route_table_id = aws_route_table.database_route_table.id

}

