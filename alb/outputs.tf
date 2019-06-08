output "alb_dns_name" {
    value = "${aws_alb.main.dns_name}"
}

# output "alb_public_ip" {
#     value = "${aws_alb.main.public_ip}"
# }

output "alb_id" {
    value = "${aws_alb.main.id}"
}

output "alb_arn" {
    value = "${aws_alb.main.arn}"
}

output "alb_zone" {
    value = "${aws_alb.main.zone_id}"
}

output "alb_target_group_arn" {
    value = "${aws_alb_target_group.main.id}"
}

output "alb_listener_front_end_tls" {
    value = "${aws_alb_listener.front_end_tls.id}"
}
