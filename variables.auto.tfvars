az1              = "ap-south-1a"
az2              = "ap-south-1b"
db_instance_type = "db.t2.micro"
db_password      = "Password1#"
db_subnet_az1    = "10.0.100.0/24"
db_subnet_az2    = "10.0.200.0/24"
db_user          = "dbuser"
hostname         = "tfe-es-guide"
instance_type    = "m5.xlarge"
region           = "ap-south-1"
#subnet                     = "10.0.6.0/24"
tfe_password               = "Password1#"
tfe_release                = "0"
vpc_network                = "10.0.0.0/16"
unique_name                = "tfe-aa-phase1"
aws_route53_zone_available = true
aws_route53_zone_name      = "fawaz-akhtar.sbx.hashidemos.io"
min_asg_size               = 1
max_asg_size               = 1
desired_asg_capacity       = 1
tfe_aa_phase2              = true
