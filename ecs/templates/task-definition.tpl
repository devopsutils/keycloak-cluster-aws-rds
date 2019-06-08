[
    {
        "memory":1024,
        "networkMode":"awsvpc",
        "cpu":512,
        "family":"keycloak",
        "portMappings": [
            {
                "hostPort": ${host_port},
                "containerPort": ${container_port},
                "protocol": "tcp"
            }
        ],
        "essential": true,
        "name": "${container_name}",
        "image": "${image_url}",
        "environment" : [
            { "name" : "KEYCLOAK_USER", "value" : "${keycloak_admin_username}" },
            { "name" : "KEYCLOAK_PASSWORD", "value" : "${keycloak_admin_password}" },
            { "name" : "PROXY_ADDRESS_FORWARDING", "value" : "true" },
            { "name" : "DB_VENDOR", "value" : "postgres" },
            { "name" : "DB_ADDR", "value" : "${database_hostname}" },
            { "name" : "DB_PORT", "value" : "${database_port}" },
            { "name" : "DB_DATABASE", "value" : "${database_name}" },
            { "name" : "DB_USER", "value" : "${database_username}" },
            { "name" : "DB_PASSWORD", "value" : "${database_password}" }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group_name}",
                "awslogs-region": "${log_group_region}"
            }
        }
    }
]