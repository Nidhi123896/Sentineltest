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
data "aws_regions" "current" {
  all_regions = true
}
resource "aws_vpc" "mainvpc" {
  
  cidr_block = "10.1.0.0/16"
}
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.mainvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}


resource "aws_cloudwatch_log_group" "nidhi" {
  name = "loggp"

  tags = {
    Environment = "production"
    Application = "serviceA"
  }
}
variable "cluster_name" {
  default = "example"
  type    = string
}

resource "aws_eks_cluster" "example" {
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = [aws_subnet.main.id]
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_cloudwatch_log_group.example,
  ]


  enabled_cluster_log_types = ["api", "audit","authenticator","controllerManager","scheduler"]
  name                      = var.cluster_name

  
}

resource "aws_cloudwatch_log_group" "example" {
 
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7
  
}
