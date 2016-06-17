resource "template_file" "user_data" {
  count    = "${var.rancher_hosts_count}"
  template = "${file("${path.module}/user_data.template")}"
  vars {
    HOSTNAME     = "rancher-host-${count.index}"
  }
}

resource "aws_instance" "rancher-hosts" {
  count                  = "${var.rancher_hosts_count}"
  ami                    = "${var.rancher_hosts_ami}"
  instance_type          = "${var.rancher_hosts_instance_type}"
  key_name               = "${var.rancher_hosts_ssh_key_name}"
  vpc_security_group_ids = ["${split("," , var.rancher_hosts_security_groups)}"]
  subnet_id              = "${element(split(",", var.rancher_hosts_private_subnets_ids), count.index)}"
  user_data              = "${element(template_file.user_data.*.rendered, count.index)}"
  #iam_instance_profile  = "${aws_iam_instance_profile.rancher_host.name}"

  tags {
    Name = "${var.environment} rancher-host-${count.index}"
    Depends_on = "${var.force_dependency}"
  }

  connection {
    user         = "${var.rancher_user}"
    bastion_host = "${var.bastion_host}"
    bastion_user = "${var.bastion_user}"
    timeout      = "20m"
  }

  provisioner "remote-exec" {
        inline = [
        "sudo apt-get update -y",
        "sudo apt-get install jq",
        "command=`curl ${var.rancher_registration_url}/v1/projects/1a5/registrationtokens | jq -r '.data[].command'`",
        "command=`echo $command|sed s/--privileged/--privileged\\ -e\\ CATTLE_AGENT_IP=${self.private_ip}/g`",
        "echo $command",
        "$command"  
        ]
  }

}

resource "aws_route53_record" "rancher-hosts-int" {
  count   = "${var.rancher_hosts_count}"
  zone_id = "${var.route53_zone_id}"
  name    = "rancher-host-${count.index}.int"
  type    = "A"
  ttl     = "60"
  records = ["${element(aws_instance.rancher-hosts.*.private_ip, count.index)}"]
}
