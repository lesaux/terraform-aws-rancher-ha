
variable "environment" { }
variable "route53_zone_id" { }
variable "bastion_host" { }
variable "bastion_user" { }
variable "rancher_user" { }
variable "rancher_hosts_count" { }
variable "rancher_hosts_ami" { }
variable "rancher_hosts_instance_type" { }
variable "rancher_hosts_ssh_key_name" { }
variable "rancher_hosts_security_groups" { }
variable "rancher_hosts_private_subnets_ids" { }
variable "rancher_hosts_public_subnets_ids" { }

variable "rancher_registration_url" { }

variable "force_dependency" { }
