data "aws_route53_zone" "main" {
  name = "${var.zone_name}"
  private_zone = false
}

resource "aws_route53_record" "cname" {
    zone_id = "${data.aws_route53_zone.main.zone_id}"
    name = "${var.public_dns_name}"
    type = "CNAME"
    ttl = "60"
    records = ["${var.alb_dns_name}"]
}

resource "aws_acm_certificate" "main" {
  domain_name = "${var.public_dns_name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "validation" {
  name    = "${aws_acm_certificate.main.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.main.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  records = ["${aws_acm_certificate.main.domain_validation_options.0.resource_record_value}"]
  ttl     = "60"
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn = "${aws_acm_certificate.main.arn}"
  validation_record_fqdns = "${aws_route53_record.validation.*.fqdn}"
}
