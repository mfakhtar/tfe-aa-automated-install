/*
resource "aws_eip" "guide-tfe-eip" {
  instance = aws_instance.guide-tfe-es-ec2.id
}

data "aws_route53_zone" "selected" {
  name         = "tf-support.hashicorpdemo.com."
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.id
  name    = "guide-tfe"
  type    = "A"
  ttl     = 300
  records = [aws_eip.guide-tfe-eip.public_ip]
}
*/

variable "aws_route53_zone_available" {
  type    = bool
  default = false
}
variable "aws_route53_zone_name" {
  default = null
}


data "aws_route53_zone" "selected" {
  #  count = var.aws_route53_zone_available ? 1 : 0
  name = var.aws_route53_zone_name
}

resource "aws_route53_record" "www" {
  #  count   = var.aws_route53_zone_available ? 1 : 0
  #  zone_id = data.aws_route53_zone.selected[count.index].zone_id
  #  name    = join(var.unique_name, data.aws_route53_zone.selected[count.index].name)
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = join(".", [var.unique_name, data.aws_route53_zone.selected.name])
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.fawaz-asg-lb.dns_name]
}

output "dns" {
  value = aws_route53_record.www.name
}