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
  depends_on = [aws_cloudwatch_log_group.example]

  enabled_cluster_log_types = ["api", "audit","authenticator","controllerManager","scheduler"]
  name                      = var.cluster_name

  
}

resource "aws_cloudwatch_log_group" "example" {
 
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7
  enabled_cluster_log_types =  true
}
