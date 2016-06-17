variable "environment" { }
variable "private_subnets_ids" { }
variable "route53_zone_id" { }
variable "sg_cidr_ingress" { }
variable "vpc_id" { }
variable "rds_family" { }
variable "rds_db_user" { }
variable "rds_instance_class" { }
variable "rds_db_pass" { }
variable "rds_db_name" { }
variable "rds_engine" { }
variable "rds_engine_version" { }
variable "rds_multi_az" { }
variable "rds_storage" { }


variable "rds_allow_major_version_upgrade" { }
variable "rds_final_snapshot_identifier" { }
variable "rds_skip_final_snapshot" { }
variable "rds_backup_retention_period" { }

variable "rds_dns_name" { }


#variable "storage" { }
#variable "instance_class" { }
#variable "db_name" { }
#variable "db_user" { }
#variable "db_pass" { }
#variable "multi_az" {  }
