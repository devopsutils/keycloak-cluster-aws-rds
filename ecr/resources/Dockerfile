FROM jboss/keycloak:6.0.1

# COPY ./extract_aws_creds.sh /opt/jboss/tools/extract_aws_creds.sh
# COPY ./custom-docker-entrypoint.sh /opt/jboss/tools/custom-docker-entrypoint.sh
# USER root

# # Ensure that the necessary utilities are installed
# RUN yum -y install wget

# # Set the custom scripts as executable
# RUN chmod +x /opt/jboss/tools/extract_aws_creds.sh
# RUN chmod +x /opt/jboss/tools/custom-docker-entrypoint.sh

# USER 1000

COPY ./standalone-ha.xml /opt/jboss/keycloak/standalone/configuration/standalone-ha.xml
ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
