provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "aws_rbtest" {
  cidr_block = "172.23.0.0/16"
  tags {
    Name = "vpcrb"
  }
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

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow all http traffic"
  vpc_id      = "${aws_vpc.aws_rbtest.id}"

  ingress {
    from_port   = 22 
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80 
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ami ubuntu
data "aws_ami" "ubuntu" {
most_recent = true
filter {
name = "name"
values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
}
filter {
name = "virtualization-type"
values = ["hvm"]
}
owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "cle_rb" {
  key_name = "rb"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKBQfsPCrZpuWJY3fFH43Wf5Vl3IwYWtNrOvz9AHW73DKyDGd+8JIQNbEl2ESdtBMPgZEpLvvYj7pZKKeVKVxRcbY90zvcqtNkD3xER6U5gJ2o99xz1wfDZDlU3yq1HH2+telhXHQoFEfahWBfAeDOdelVTExRJY4uJfUntHWufQ4X9XcaiAbaEQ3m89Cc3/ESijrg0tCR4wF9I8X1PEl7k1P0UB4VVWUqTU18spbNHGOA816qyvhv1pA2x6pV4fvMjDKYQ0bJp5fGjFTGZZtL3d/s4UGOAzr8yv+6Qh3S5JPT4v6kWqaJecJot18Hh3FKjqeD16Nq/TS9gbjV/6in ec2-user@ip-172-31-11-67²"
}
################ instance
resource "aws_instance" "web" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.pubnet1.id}"
  associate_public_ip_address = true
  key_name = "${aws_key_pair.cle_rb.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]

  tags {
    Name = "helloword"
  }
}
