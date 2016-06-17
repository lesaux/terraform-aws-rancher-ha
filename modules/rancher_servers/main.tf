resource "template_file" "user_data" {
  count    = "${var.rancher_servers_count}"
  template = "${file("${path.module}/user_data.template")}"
  vars {
    HOSTNAME   = "rancher-server-${count.index}"
  }
}

resource "template_file" "rancher-ha" {
  template = "${file("${path.module}/rancher-ha.template")}"
  vars {
    CATTLE_HA_HOST_REGISTRATION_URL  = "${var.rancher_registration_url}"
    CATTLE_DB_CATTLE_MYSQL_HOST      = "${var.rds_address}"
    CATTLE_DB_CATTLE_MYSQL_NAME      = "${var.rds_db_name}"
    CATTLE_DB_CATTLE_USERNAME        = "${var.rds_db_user}"
    CATTLE_DB_CATTLE_PASSWORD        = "${var.rds_db_token}"
    ENCRYPTION_KEY                   = "${var.rancher_encryption_key}"
  }
}

resource "template_file" "rancher-ha-start" {
  template = "${file("${path.module}/rancher-ha-start.template")}"
}


resource "aws_instance" "rancher-servers" {
  count                  = "${var.rancher_servers_count}"
  ami                    = "${var.rancher_servers_ami}"
  instance_type          = "${var.rancher_servers_instance_type}"
  key_name               = "${var.rancher_servers_ssh_key_name}"
  vpc_security_group_ids = ["${split("," , var.rancher_servers_security_groups)}"]
  subnet_id              = "${element(split(",", var.rancher_servers_private_subnets_ids), count.index)}"
  user_data              = "${element(template_file.user_data.*.rendered, count.index)}"
  #iam_instance_profile  = "${aws_iam_instance_profile.rancher_host.name}"

  tags {
    Name = "${var.environment} rancher-server-${count.index}"
  }

  connection {
    user         = "${var.rancher_user}"
    bastion_host = "${var.bastion_host}"
    bastion_user = "${var.bastion_user}"
    timeout      = "20m"
  }

  provisioner "remote-exec" {
        inline = [
        "echo \"${template_file.rancher-ha.rendered}\" > rancher-ha.sh",
        "sudo bash rancher-ha.sh",
        "echo \"${template_file.rancher-ha-start.rendered}\" > rancher-ha-start.sh",
        "sudo mv /home/rancher/rancher-ha-start.sh /var/lib/rancher/bin/rancher-ha-start.sh",
        "sudo chmod +x /var/lib/rancher/bin/rancher-ha-start.sh"
        ]
  }

}

resource "aws_route53_record" "rancher-servers-int" {
  count   = "${var.rancher_servers_count}"
  zone_id = "${var.route53_zone_id}"
  name    = "rancher-server-${count.index}.int"
  type    = "A"
  ttl     = "60"
  records = ["${element(aws_instance.rancher-servers.*.private_ip, count.index)}"]
}
