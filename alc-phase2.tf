resource "aws_launch_configuration" "fawaz-tfe-aa" {
  image_id        = "ami-0f8ca728008ff5af4"
  instance_type   = var.instance_type
  key_name        = aws_key_pair.ssh_key_pair.key_name
  security_groups = [aws_security_group.guide-tfe-es-sg.id]
  root_block_device {
    volume_size = "50"
  }

  user_data = templatefile("${path.module}/user-data-phase2.sh", {
    bucket_name  = local.bucket_name
    region       = var.region
    tfe_password = var.tfe_password
    tfe_release  = var.tfe_release
    db_name      = aws_db_instance.default.db_name
    db_address   = aws_db_instance.default.address
    db_user      = var.db_user
    db_password  = var.db_password
    redis_host   = lookup(aws_elasticache_cluster.example.cache_nodes[0], "address", "No redis created")
  })

  iam_instance_profile = aws_iam_instance_profile.guide-tfe-es-inst.id


  lifecycle {
    create_before_destroy = true
  }

}