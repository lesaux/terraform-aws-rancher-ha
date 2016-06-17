variable "name" { }
variable "environment" { }
variable "cidr" { }
variable "public_subnets" { default = "" }
variable "private_subnets" { default = "" }
variable "azs" { }
variable "enable_dns_hostnames" { default = true }
variable "enable_dns_support" { default = true }
variable "bastion_ssh_key_name" { }
variable "bastion_instance_type" { }
variable "bastion_ami" { }
variable "domain_name" { }
variable "route53_zone_id" { }
