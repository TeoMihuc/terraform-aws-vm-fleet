resource "aws_vpc" "vpc_fleet" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.vpc_tags_name
  }
}

resource "aws_subnet" "subnet_fleet" {
  vpc_id            = aws_vpc.vpc_fleet.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avz
  tags = {
    Name = var.subnet_tags_name
  }
}

resource "aws_security_group" "ingress-all" {
  name = "allow-all-sg"
  vpc_id = aws_vpc.vpc_fleet.id
  ingress {
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      from_port = 0
      to_port = 22
      protocol = "tcp"
    }
  // Terraform removes the default rule
    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.vpc_fleet.id
  tags = {
      Name = "test-env-gw"
    }
}

resource "aws_route_table" "route-table-test-env" {
  vpc_id = aws_vpc.vpc_fleet.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.internet-gw.id
    }
  tags = {
      Name = "test-env-route-table"
    }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.subnet_fleet.id
  route_table_id = aws_route_table.route-table-test-env.id
}

resource "aws_security_group" "private-sg" {

  name = "allowinternal-sg"
  vpc_id = aws_vpc.vpc_fleet.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [ aws_security_group.ingress-all.id ]
    self = true
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}