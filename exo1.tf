provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "aws_rbtest" {
  cidr_block = "172.23.0.0/16"
}


