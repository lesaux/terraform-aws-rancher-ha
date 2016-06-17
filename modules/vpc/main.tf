resource "aws_vpc" "mod" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"
  tags { 
    Name = "${var.name}"
    Environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "mod" {
  vpc_id = "${aws_vpc.mod.id}"
}

resource "aws_eip" "natgw" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.natgw.id}"
  subnet_id     = "${aws_subnet.public.0.id}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.mod.id}"
  tags {
    Name = "${var.name}-public"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "public_internet_gateway" {
    route_table_id = "${aws_route_table.public.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mod.id}"
}

resource "aws_route" "private_internet_gateway" {
    route_table_id = "${aws_route_table.private.id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw.id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.mod.id}"
  tags { 
    Name = "${var.name}-private"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.mod.id}"
  cidr_block = "${element(split(",", var.private_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  #temp workaround for TF bug
  #count = "${length(compact(split(",", var.private_subnets)))}"
  count = 3
  tags {
    Name = "${var.name}-private-${count.index}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.mod.id}"
  cidr_block = "${element(split(",", var.public_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  #temp workaround for TF bug
  #count = "${length(compact(split(",", var.public_subnets)))}"
  count = 3
  tags { 
    Name = "${var.name}-public-${count.index}"
    Environment = "${var.environment}"
  }

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "private" {
  #temp workaround for TF bug
  #count = "${length(compact(split(",", var.private_subnets)))}"
  count = 3
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
  #temp workaround for TF bug
  #count = "${length(compact(split(",", var.public_subnets)))}"
  count = 3
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

