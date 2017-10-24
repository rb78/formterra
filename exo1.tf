provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "aws_rbtest" {
  cidr_block = "172.23.0.0/16"
}

resource "aws_subnet" "pubnet1" {
  vpc_id            = "${aws_vpc.aws_rbtest.id}"
  cidr_block        = "172.23.1.0/24"
  availability_zone = "eu-west-1a"
}

resource "aws_subnet" "pubnet2" {
  vpc_id            = "${aws_vpc.aws_rbtest.id}"
  cidr_block        = "172.23.2.0/24"
  availability_zone = "eu-west-1b"
}
