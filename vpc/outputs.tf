# output "vpc_arn" {
#     value = "${aws_vpc.primary_vpc.vpc_arn}"
# }

output "vpc_id" {
    value = "${aws_vpc.primary_vpc.id}"
}

output "vpc_zone_identifier" {
    value = "${aws_subnet.public.*.id}"
}

output "instance_sg_id" {
    value = "${aws_security_group.instance_sg.id}"
}

output "public_subnet_ids" {
    value = "${aws_subnet.public.*.id}"
}

output "private_subnet_ids" {
    value = "${aws_subnet.private.*.id}"
}

output "public_subnet_cidr" {
    value = "${var.public_subnet_cidr_block}"
}

output "private_subnet_cidr" {
    value = "${var.private_subnet_cidr_block}"
}

output "security_groups" {
    value = ["${aws_security_group.alb_sg.id}"]
}

output "private_subnet_group_name" {
    value = "${aws_subnet.private}"
}