output "endpoint" {
  value = "${aws_db_instance.mysql.address}"
}

output "security_group_db" {
  value = "${aws_security_group.db.id}"
}

