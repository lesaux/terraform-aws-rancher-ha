resource "aws_instance" "bastion" {
  ami                    = "${var.bastion_ami}"
  instance_type          = "${var.bastion_instance_type}"
  key_name               = "${var.bastion_ssh_key_name}"
  vpc_security_group_ids = ["${aws_security_group.vpc_internal.id}", "${aws_security_group.bastion.id}"]
  subnet_id              = "${aws_subnet.public.0.id}"

  tags {
    Name = "${var.environment} bastion"
  }

}

resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true
}

resource "aws_route53_record" "bastion" {
  depends_on = ["aws_eip.bastion"]
  zone_id    = "${var.route53_zone_id}"
  name       = "bastion"
  type       = "A"
  ttl        = "60"
  records    = ["${aws_eip.bastion.public_ip}"]
}

resource "aws_route53_record" "bastion-int" {
  zone_id = "${var.route53_zone_id}"
  name    = "bastion.int"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.bastion.private_ip}"]
}
