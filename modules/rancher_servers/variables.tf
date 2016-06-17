
variable "environment" { }
variable "route53_zone_id" { }
variable "bastion_host" { }
variable "bastion_user" { }
variable "rancher_user" { }
variable "rancher_servers_count" { }
variable "rancher_servers_ami" { }
variable "rancher_servers_instance_type" { }
variable "rancher_servers_ssh_key_name" { }
variable "rancher_servers_security_groups" { }
variable "rancher_servers_private_subnets_ids" { }
variable "rancher_servers_public_subnets_ids" { }

variable "rancher_url" { }
variable "rancher_registration_url" { }
variable "rancher_encryption_key" { }
variable "rds_address" { }
variable "rds_db_name" { }
variable "rds_db_user" { }
variable "rds_db_pass" { }
variable "rds_db_token" { }

