provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "vpcsg" {
  cidr_block = "10.0.0.0/16"
  
}
resource "aws_subnet" "mainone" {
  vpc_id     = aws_vpc.vpcsg.id
  cidr_block = "10.0.1.0/24"
  
  availability_zone ="us-east-1c"
 
  tags = {
    Name = "subnet1"
  }
}
resource "aws_subnet" "maintwo" {
  vpc_id     = aws_vpc.vpcsg.id
  cidr_block = "10.0.2.0/24"
 
  availability_zone = "us-east-1d"
  tags = {
    Name = "subnet2"
  }
}

resource "aws_security_group" "allow_tlss" {
  name        = "allow"
  description = "Allow TLS inbound traffic"
 vpc_id      = aws_vpc.vpcsg.id
  
  tags = {
    Name = "ingress"
  }
}


resource "aws_instance" "my-ec2" {
  ami ="ami-087c17d1fe0178315"
  instance_type = "t2.micro"
 
  #role= "aws_iam_role.EC2S3TF1.name"
  #iam_instance_profile = [aws_iam_instance_profile.EC2S3TF1.name]
  vpc_security_group_ids = ["${aws_security_group.allow_tlss.id}"]
   subnet_id = aws_subnet.maintwo.id
  tags = {
    ec2_create = "instance1"
  }
}

resource "aws_security_group_rule" "rule1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule2" {
  type              = "ingress"
  #self              = true
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule3" {
  type              = "ingress"
  #self              = true
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["100.64.0.0/10"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule4" {
   type              = "ingress"
  #self              = true
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["198.19.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule5" {
 type              = "ingress"
  #self              = true
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule6" {
  type              = "ingress"
  #self              = true
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["172.16.0.0/12"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule7" {
 type              = "ingress"
  #self              = true
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["192.168.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}

