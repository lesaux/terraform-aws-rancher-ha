output "private_subnets_ids" {
  value = "${join(",", aws_subnet.private.*.id)}"
  #value = "${aws_subnet.private.*.id}"
}

output "public_subnets_ids" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "vpc_id" {
  value = "${aws_vpc.mod.id}"
}

output "public_route_table_id" {
  value = "${aws_route_table.public.id}"
}

output "private_route_table_id" {
  value = "${aws_route_table.private.id}"
}

output "security_group_internal" {
  value = "${aws_security_group.vpc_internal.id}"
}

output "security_group_public_web" {
  value = "${aws_security_group.public_web.id}"
}

output "bastion_public_ip" {
  value = "${aws_eip.bastion.public_ip}"
}
