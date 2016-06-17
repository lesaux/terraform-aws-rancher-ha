## Global env variables
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "route53_zone_id" {}
variable "domain_name" {}
variable "aws_region" { default = "us-east-1" }
variable "environment_name" { default = "dev" }

## VPC Variables
variable "vpc_name" { default = "rancher-dev-vpc" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "vpc_private_subnets" { default = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24" }
variable "vpc_public_subnets" { default = "10.0.101.0/24,10.0.102.0/24,10.0.103.0/24" }
variable "vpc_zones" { default = "us-east-1a,us-east-1b,us-east-1d" }

## Bastion Variables
variable "bastion_user" { default = "ubuntu" }
variable "bastion_key_name" { default  = "MyKeyPair" }
variable "bastion_instance_type" { default  = "t2.micro" }
variable "bastion_ami" { default = "ami-fce3c696" }

## RDS Variables
variable "rds_family" { default = "mysql5.7" }
variable "rds_dns_name" { default = "mysql" }
variable "rds_db_name" { default = "rancher" }
variable "rds_db_user" { default = "rancher_user" }
variable "rds_db_pass" { default = "rancher_password" }
variable "rds_storage" { default = 10 }
variable "rds_engine" { default = "mysql" }
variable "rds_engine_version" { default = "5.7.10" }
variable "rds_instance_class" { default = "db.t2.medium" }
variable "rds_multi_az" { default = true }
variable "rds_allow_major_version_upgrade" { default = false }
variable "rds_final_snapshot_identifier" { default = "rancher-final" }
variable "rds_skip_final_snapshot" { default = false }
variable "rds_backup_retention_period" { default = 5 }

## Jenkins Variables
variable "jenkins_ami" { default = "ami-fce3c696" }
variable "jenkins_instance_type" { default = "t2.micro" }
variable "jenkins_ssh_key_name" { default = "MyKeyPair" }
variable "jenkins_ebs_size" { default = 10 }
variable "jenkins_ebs_volume_name" { default = "/dev/xvdh" }
 
## Rancher servers variables
variable "rancher_user" { default = "rancher" }
variable "rancher_servers_count" { default = 3 }
variable "rancher_servers_ami" { default = "ami-880f12e2" }  
variable "rancher_servers_instance_type" { default = "m3.medium" }
variable "rancher_servers_ssh_key_name" { default = "MyKeyPair" }
variable "rancher_encryption_key" { default = "o0ocicjJxsv9V4dDDArY4gxrzTGvIKBdrZq3Z18fVqc=" }
variable "rds_db_token" { default = "2a28ef47e6289f59e676e2fdf573e7f9:6b5976bcc530c5138ba50f1579a29fda0148f3e29886cd73fca8424ff5a5bba9" }
variable "rancher_url" { default = "rancher" } #as in rancher.domain.name
variable "rancher_protocol" { default = "http" } #currently not using ssl.

## Rancher hosts variables
variable "rancher_hosts_count" { default = 3 }
variable "rancher_hosts_ami" { default = "ami-880f12e2" }  
variable "rancher_hosts_instance_type" { default = "m3.medium" }
variable "rancher_hosts_ssh_key_name" { default = "MyKeyPair" }
