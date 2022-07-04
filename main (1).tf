provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_iam_role" "example" {
  name = "eks-cluster-example"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example.name
}

resource "aws_vpc" "mainvpc" {
 
  cidr_block = "10.1.0.0/16"
}
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = "10.1.1.0/24"
  
  availability_zone = data.aws_availability_zones.available.names[0]
 
  tags = {
    Name = "subnet1"
  }
}
resource "aws_subnet" "main1" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = "10.1.2.0/24"
 
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "subnet2"
  }
}



resource "aws_cloudwatch_log_group" "nidhi" {
  name = "loggp"

  tags = {
    Environment = "production"
    Application = "service"
  }
}
variable "cluster_name" {
  default = "example"
  type    = string
}

resource "aws_eks_cluster" "example" {
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = [aws_subnet.main.id,aws_subnet.main1.id]
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_cloudwatch_log_group.example,
  ]


  #enabled_cluster_log_types = ["api", "audit","authenticator","controllerManager","scheduler"]
  name                      = var.cluster_name

  
}

resource "aws_cloudwatch_log_group" "example" {
 
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7
  
}
