#Add Provider Block
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}


#Add EC2 Block
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

/*
resource "aws_instance" "guide-tfe-es-ec2" {
  availability_zone           = var.az1
  ami                         = "ami-0f8ca728008ff5af4"
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.guide-tfe-es-sg.id]
  subnet_id                   = aws_subnet.guide-tfe-es-sub.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key_pair.key_name

  root_block_device {
    volume_size = "50"
  }

  tags = {
    Name = var.unique_name
  }

/*
  user_data = templatefile("${path.module}/user-data.sh", {
    bucket_name  = local.bucket_name
    region       = var.region
    tfe_password = var.tfe_password
    tfe_release  = var.tfe_release
    db_name      = aws_db_instance.default.db_name
    db_address   = aws_db_instance.default.address
    db_user      = var.db_user
    db_password  = var.db_password
  })
  iam_instance_profile = aws_iam_instance_profile.guide-tfe-es-inst.id

}
*/

/*
output "replicated-ui" {
  value = "https://${aws_eip.bar.public_dns}:8800/"
}
*/