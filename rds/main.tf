resource "aws_security_group" "keycloakdb_sg" {

    name = "keycloakdb_sg"
    description = "Security group for connecting to the KeyCloak database instance"

    vpc_id = "${var.vpc_id}"

    # Only PostgreSQL traffic inbound
    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        security_groups = ["${var.instance_security_group}"]
    }

    # egress {
    #     from_port = 80
    #     to_port = 80
    #     protocol = "tcp"
    #     cidr_blocks = ["0.0.0.0/0"]
    # }

    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_db_subnet_group" "main" {

    name = "keycloak_db_sng"
    subnet_ids = concat("${var.public_subnet_ids}", "${var.private_subnet_ids}")

}
resource "aws_db_instance" "keycloakdb" {
  
  allocated_storage = "${var.rds_storage_gigabytes}"
  backup_retention_period = "${var.rds_backup_retention_days}"

  db_subnet_group_name = "${aws_db_subnet_group.main.name}"

  engine = "${var.rds_engine}"
  engine_version = "${var.rds_engine_version}"
  multi_az = "${var.rds_multi_az}"
  instance_class = "${var.instance_type}"

  identifier = "${var.rds_name}"
  name = "${var.rds_name}"

  username = "${var.rds_username}"
  password = "${var.rds_password}"
  
  publicly_accessible = false
  storage_encrypted = true

  vpc_security_group_ids = ["${aws_security_group.keycloakdb_sg.id}"]

  skip_final_snapshot = true
}
