provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "aws_rbtest" {
  cidr_block = "172.23.0.0/16"
}

resource "aws_internet_gateway" "gateway_rbtest" {
  vpc_id            = "${aws_vpc.aws_rbtest.id}"
}

resource "aws_route_table" "route_internet" {
  vpc_id            = "${aws_vpc.aws_rbtest.id}"
  route {
     cidr_block ="0.0.0.0/0"
     gateway_id = "${aws_internet_gateway.gateway_rbtest.id}"
  }
}

resource "aws_route_table_association" "route_subnet1" {
  subnet_id = "${aws_subnet.pubnet1.id}"
  route_table_id = "${aws_route_table.route_internet.id}"
}

resource "aws_subnet" "pubnet1" {
  vpc_id            = "${aws_vpc.aws_rbtest.id}"
  cidr_block        = "172.23.1.0/24"
  availability_zone = "eu-west-1a"
}

resource "aws_route_table_association" "route_subnet2" {
  subnet_id = "${aws_subnet.pubnet2.id}"
  route_table_id = "${aws_route_table.route_internet.id}"
}

resource "aws_subnet" "pubnet2" {
  vpc_id            = "${aws_vpc.aws_rbtest.id}"
  cidr_block        = "172.23.2.0/24"
  availability_zone = "eu-west-1b"
}
