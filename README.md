## keycloak-cluster-aws-rds

A sample Terraform setup for creating an auto-scaling KeyCloak cluster behind an ALB

## What

This project demonstrates how to launch a cluster of [KeyCloak](https://keycloak.org) instances with a PostgreSQL [RDS](https://aws.amazon.com/rds/) backend within your AWS [VPC](https://aws.amazon.com/vpc/) using [Terraform](https://terraform.io).  These modules will deploy KeyCloak within auto-scaling Docker containers deployed on EC2, accessible behind an [ALB](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html).  A DNS record for the instance will also be created using [Route 53](https://aws.amazon.com/route53/) and a corresponding certificate for the ALB will be created and applied using [ACM](https://aws.amazon.com/certificate-manager/).

## Getting Started

#### Docker

This code assumes you have [Docker](https://www.docker.com) installed locally.  As part of the Terraform code, a new Docker image is built and pushed to an [AWS ECR](https://aws.amazon.com/ecr/) repository.  The reason for this is the standard KeyCloak Docker image does not include support for JDBC_PING as a cluster management protocol.  In a non-AWS environment, multicast would be used to locate cluster members.  Since AWS does not support multicast, this information is instead stored in an RDS database accessible by cluster members.  A custom ```standalone-ha.xml``` file is added to a custom KeyCloak Docker image created by this code to support this functionality.

### Terraform
This code has been tested using Terraform 0.12.0.  If you are running a newer version of Terraform, you may need to make some changes and tweaks.  After cloning this repo, within the source directory run:

```
terraform init
```

This will ensure that the modules are registered and any required providers are downloaded.  Now that the build environment is initialized, you must define the values for the variables needed by the Terraform modules.  You may either do this as `terraform apply` is run, or you may use a var file.  To use a var file (in this case, called `private.tfvars`) simple run:

```
terraform plan -var-file=private.tfvars
```

If everything in the plan looks appropriate, you may apply the Terraform module and begin building out your infrastructure by running:

```
terraform apply -var-file=private.tfvars
```

## Testing it out

Once your Terraform build completes, you will see outputs showing the ALB's DNS name, as well as the DNS name created using Route 53.  Wait a couple seconds for the ALB to register the backend targets, and then open up a browser to either of those values.  You should see the KeyCloak login page appear.  Login with the administrator username and password you provided as part of your Terraform variables.  You can also login to the AWS CloudWatch console to view the KeyCloak logs.  There, you should see 2 instances of KeyCloak operating in a cluster.

## Caveats

A few caveats, particularly related to security...

#### JDBC_PING vs. S3_PING

As multicast is not support within AWS, the normal jGroups cluster maintenance protocol will not work.  There are two options available to us in the AWS environment:  ```S3_PING``` and ```JDBC_PING```.  The S3_PING mechanism utilizes a shared S3 bucket for maintaining information on cluster members.  The JDBC_PING mechanism uses a backend database for this information.

While S3_PING may be more convenient and give us easier insight into cluster members, Wildfly does not support grabbing the AWS access key and secret key using the instance metadata.  As a result, you are forced to specify the access key and secret key within your Wildfly configuration file.  This is less than ideal, as it would require us to run scripts to grab this information when the Docker container starts up, then either set environment variables (very insecure) or update the configuration file on the filesystem (still insecure).

For this deployment, I am leveraging JDBC_PING rather than S3_PING to reduce some of these security issues.  The ping table is maintained in the same database that KeyCloak uses for its user data, provided via RDS.

#### Route 53 and DNS

This deployment assumes that you have an existing Route 53 zone setup for your domain.  The DNS record for KeyCloak will created in this zone during ```apply```, but the zone itself must exist beforehand.

#### RDS Credentials

Due to shortcomings in the way that the KeyCloak Docker image and underlying application server work, RDS credentials are provided as part of the ECS task definition and made available to KeyClok as environment variables.  This is less than ideal, but I'm not knowledgeable enough on Terraform to come up with a better way.  If you have one, feel free to raise an issue or submit a pull request!

#### RDS Database Engine

This code is based off of an RDS instance running PostgreSQL.  It's likely that you could change the database engine to MySQL or another database supported by KeyCloak, but this functionality has not been tested.  It is also important to note that there is no Multi-AZ capability enabled in this code, nor is there any sort of replication defined.

## Questions/Issues

Find a bug?  Have an idea on how to better implement a section of the code?  Have a general question?  Feel free to raise an issue or submit a pull request!  I can't guarantee that I have all the answers, as this project is really just an exercise to help me learn Terraform better.  But I'll certainly give it my best shot.