from diagrams import Diagram, Cluster
from diagrams.aws.compute import EC2, EC2ElasticIpAddress
from diagrams.aws.database import RDS
from diagrams.aws.network import VPC, Route53, PrivateSubnet, PublicSubnet
from diagrams.aws.storage import S3
from diagrams.onprem.client import User

# Create the diagram
with Diagram("AWS Infrastructure", show=False, direction="TB"):

    # Define the AWS account and region
    user = User("User")
    aws = Cluster("AWS Account")
    with aws:
        with Cluster("ap-fawaz-1"):
            with Cluster("VPC"):
                record = Route53("guide-tfe")
                eip = EC2ElasticIpAddress("EIP")
                ec2 = EC2("TFE")
                s3 = S3("S3")
                rds = RDS("DB")

                user >> record >> eip >> ec2 >> [ rds, s3 ]
