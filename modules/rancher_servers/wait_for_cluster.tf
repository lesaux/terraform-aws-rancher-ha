resource "null_resource" "wait_for_cluster" {

    depends_on = [ "null_resource.launch_ha_servers" ]

    connection {
      host = "${var.bastion_host}"
      user = "${var.bastion_user}"
    }

    provisioner "remote-exec" {
        inline = [
        "until $(curl --output /dev/null --silent --head --fail ${var.rancher_registration_url}); do printf 'waiting for cluster'; sleep 5; done; printf 'cluster is ready'",
        "printf 'creating host registration token'",
        "curl -s -X POST '${var.rancher_registration_url}/v1/registrationtokens?projectId=1a5'"
        ]
    }

}
