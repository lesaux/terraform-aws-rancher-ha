resource "null_resource" "launch_ha_servers" {

    depends_on = [ "null_resource.create_database" ]

    count = "${var.rancher_servers_count}"

    connection {
      host         = "${element(aws_instance.rancher-servers.*.private_ip, count.index)}"
      user         = "${var.rancher_user}"
      bastion_host = "${var.bastion_host}"
      bastion_user = "${var.bastion_user}"
      timeout      = "20m"
    }

    provisioner "remote-exec" {
        inline = [
        "sudo /var/lib/rancher/bin/rancher-ha-start.sh rancher/server"
        ]
    }

}
