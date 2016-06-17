resource "aws_security_group" "vpc_internal" {
  name        = "vpc_internal"
  description = "Allow all traffic inside vpc"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}_vpc_internal"
  }

  vpc_id = "${aws_vpc.mod.id}"
}

resource "aws_security_group" "public_web" {
  name        = "public_web"
  description = "Allow web traffic 80/443"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}_public_web"
  }

  vpc_id = "${aws_vpc.mod.id}"
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow SSH and port 8080 traffic from the internet"
  #port 8080 is needed for the initial rancher-ha setup

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.environment}_bastion"
  }

  vpc_id = "${aws_vpc.mod.id}"
}
