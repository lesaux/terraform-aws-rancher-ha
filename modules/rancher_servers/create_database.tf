resource "null_resource" "create_database" {

    depends_on = [ "aws_instance.rancher-servers" ]

    connection {
      host = "${var.bastion_host}"
      user = "${var.bastion_user}"
    }

    provisioner "file" {
      source = "${path.module}/rancher_prod_bootstrap.sql"
      destination = "/home/${var.bastion_user}/rancher_prod_bootstrap.sql" 
    }

    provisioner "remote-exec" {
        inline = [
        "sudo apt-get update -y",
        "sudo apt-get install mysql-client -y",
        "mysql -u${var.rds_db_user} -p${var.rds_db_pass} -h${var.rds_address} ${var.rds_db_name}  < /home/${var.bastion_user}/rancher_prod_bootstrap.sql"
        ]
    }

}

