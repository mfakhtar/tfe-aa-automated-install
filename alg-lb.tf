resource "aws_launch_configuration" "fawaz-tfe-es" {
  image_id        = "ami-0f8ca728008ff5af4"
  instance_type   = var.instance_type
  key_name        = aws_key_pair.ssh_key_pair.key_name
  security_groups = [aws_security_group.guide-tfe-es-sg.id]
  root_block_device {
    volume_size = "50"
  }

  user_data = templatefile("${path.module}/user-data-phase1.sh", {
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


  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "fawaz-tfe-es-asg" {
  launch_configuration = var.tfe_aa_phase2 ? aws_launch_configuration.fawaz-tfe-es.name : aws_launch_configuration.fawaz-tfe-aa.name
  vpc_zone_identifier  = local.public_subnets

  target_group_arns         = [aws_lb_target_group.asg-target-replicated.arn, aws_lb_target_group.asg-target-http.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 3600

  min_size         = var.min_asg_size
  max_size         = var.max_asg_size
  desired_capacity = var.desired_asg_capacity

  tag {
    key                 = "Name"
    value               = "fawaz-terraform-eg-asg"
    propagate_at_launch = true
  }

}

locals {
  public_subnets = aws_subnet.fawaz-tfe-es-pub-sub[*].id
}

resource "aws_lb" "fawaz-asg-lb" {
  name               = "fawaz-asg-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = local.public_subnets
  security_groups    = [aws_security_group.guide-tfe-es-sg.id]
}

resource "aws_lb_listener" "fawaz-asg-lb-listner-replicated" {
  load_balancer_arn = aws_lb.fawaz-asg-lb.arn
  port              = "8800"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg-target-replicated.arn
  }
}

resource "aws_lb_listener" "fawaz-asg-lb-listner-http" {
  load_balancer_arn = aws_lb.fawaz-asg-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg-target-http.arn
  }

}

resource "aws_lb_target_group" "asg-target-http" {
  name     = "asg-target-http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.guide-tfe-es-vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "301"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

}

resource "aws_lb_target_group" "asg-target-replicated" {
  name     = "asg-target-replicated"
  port     = 8800
  protocol = "HTTP"
  vpc_id   = aws_vpc.guide-tfe-es-vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "303"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}