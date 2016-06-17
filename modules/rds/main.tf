resource "aws_db_subnet_group" "default" {
  name        = "db_subnet_group"
  description = "DB Subnet Group on Private ${var.environment} Subnets"
  subnet_ids  = ["${split(",", var.private_subnets_ids)}"]

  tags {
    Name = "${var.environment} DB Subnet Group"
  }
}

resource "aws_db_parameter_group" "default" {
  name        = "${var.environment}-rancher-mysql"
  family      = "${var.rds_family}"
  description = "RDS default parameter group"
}

resource "aws_security_group" "db" {
  name        = "db_security_group"
  description = "Allow connection to DB"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.sg_cidr_ingress}"]
  }

  tags {
    Name = "${var.environment}_db"
  }

  vpc_id = "${var.vpc_id}"
}

resource "aws_db_instance" "mysql" {
  identifier                  = "${var.environment}-rancher"
  allocated_storage           = "${var.rds_storage}"
  engine                      = "${var.rds_engine}"
  engine_version              = "${var.rds_engine_version}"
  instance_class              = "${var.rds_instance_class}"
  name                        = "${var.rds_db_name}"
  username                    = "${var.rds_db_user}"
  password                    = "${var.rds_db_pass}"
  vpc_security_group_ids      = ["${aws_security_group.db.id}"]
  db_subnet_group_name        = "${aws_db_subnet_group.default.name}"
  multi_az                    = "${var.rds_multi_az}"
  parameter_group_name        = "${aws_db_parameter_group.default.name}"
  allow_major_version_upgrade = "${var.rds_allow_major_version_upgrade}"
  final_snapshot_identifier   = "${var.rds_final_snapshot_identifier}"
  skip_final_snapshot         = "${var.rds_skip_final_snapshot}"
  backup_retention_period     = "${var.rds_backup_retention_period}"
}
