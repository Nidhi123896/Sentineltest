provider "aws" {
  region = "us-east-1"
}

variable "sg_ingress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_block  = string
      description = string
    }))
    default     = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_block  = "10.1.0.0/16"
          description = "test"
        },
        {
          from_port   = 23
          to_port     = 23
          protocol    = "tcp"
          cidr_block  = "10.1.0.0/16"
          description = "test"
        },
    ]
}
resource "aws_default_vpc" "main" {
  tags = {
    Name = "main"
  }
}
resource "aws_security_group" "allow_tls" {
  name        = "allow"
  description = "Allow TLS inbound traffic"
 vpc_id      = aws_default_vpc.main.id
tags = {
    Name = "ingressrule"
  }
}


resource "aws_instance" "my-ec2" {
  ami ="ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  #role= "aws_iam_role.EC2S3TF1.name"
  #iam_instance_profile = [aws_iam_instance_profile.EC2S3TF1.name]
  security_groups = [aws_security_group.allow_tls.name]
  tags = {
    ec2_create = "instance1"
  }
}


 resource "aws_security_group_rule" "ingress_rules" {
  count = length(var.sg_ingress_rules)

  type              = "ingress"
  self              = true
  from_port         = var.ingress_rules[count.index].from_port
  to_port           = var.ingress_rules[count.index].to_port
  protocol          = var.ingress_rules[count.index].protocol
  cidr_blocks       = [var.ingress_rules[count.index].cidr_block]
  description       = var.ingress_rules[count.index].description
  security_group_id = aws_security_group.allow_tls.id
}
