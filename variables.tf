variable "region" {}

variable "az1" {
  description = "Availability Zone"
}

variable "az2" {
  description = "Availability Zone"
}

variable "vpc_network" {}
#variable "subnet" {}

variable "db_instance_type" {}
variable "db_user" {}
variable "db_password" {}
variable "db_subnet_az1" {}
variable "db_subnet_az2" {}

variable "hostname" {
  description = "tfe ec2 instance hostname"
}

variable "instance_type" {
  description = "tfe ec2 instance_type"
}


variable "tfe_password" {}
variable "tfe_release" {
  description = "tfe release we want to install"
}

variable "unique_name" {}

variable "min_asg_size" {}
variable "max_asg_size" {}
variable "desired_asg_capacity" {}
variable "tfe_aa_phase2" {}