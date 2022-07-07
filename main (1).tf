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
    Name = "ingressrule"
  }
}


resource "aws_instance" "my-ec2" {
  ami ="ami-087c17d1fe0178315"
  instance_type = "t2.micro"
  #role= "aws_iam_role.EC2S3TF1.name"
  #iam_instance_profile = [aws_iam_instance_profile.EC2S3TF1.name]
  security_groups = [aws_security_group.allow_tlss.id]
  
  tags = {
    ec2_create = "instance1"
  }
}

resource "aws_security_group_rule" "rule1" {
  type              = "ingress"
  from_port         = 1434
  to_port           = 1434
  protocol          = "udp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule2" {
  type              = "ingress"
  #self              = true
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule3" {
  type              = "ingress"
  #self              = true
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule4" {
  type              = "ingress"
  #self              = true
  from_port         = 4333
  to_port           = 4333
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule5" {
  type              = "ingress"
  #self              = true
  from_port         = 1433
  to_port           = 1433
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule6" {
  type              = "ingress"
  #self              = true
  from_port         = 5500
  to_port           = 5500
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule7" {
  type              = "ingress"
  #self              = true
  from_port         = 445
  to_port           = 445
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule8" {
  type              = "ingress"
  #self              = true
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule9" {
  type              = "ingress"
  #self              = true
  from_port         = 135
  to_port           = 135
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}

resource "aws_security_group_rule" "rule10" {
  type              = "ingress"
  #self              = true
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}

resource "aws_security_group_rule" "rule11" {
  type              = "ingress"
  #self              = true
  from_port         = 23
  to_port           = 23
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}



