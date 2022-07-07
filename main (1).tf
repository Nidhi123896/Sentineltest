provider "aws" {
  region = "us-east-1"
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

  ingress {
    description      = "TLS from VPC"
    from_port        = 23
    to_port          = 23
    protocol         = "tcp"
    self            = true
    cidr_blocks      = ["10.1.0.0/16"]
  }
   ingress {
    from_port        = 22
    to_port          = 22
    protocol         ="tcp"
    self            = true
    cidr_blocks      = ["10.1.0.0/16"]
   }
   ingress {
    from_port        = 135
    to_port          = 135
    protocol         ="tcp"
    self            = true
    cidr_blocks      = ["10.1.0.0/16"]
   }
   ingress {
    from_port        = 445
    to_port          = 445
    protocol         ="tcp"
    self            = true
    cidr_blocks      = ["10.1.0.0/16"]
   }
   ingress {
    from_port        = 3389
    to_port          = 3389
    protocol         ="tcp"
    self            = true
    cidr_blocks      = ["10.1.0.0/16"]
   }
   ingress {
    from_port        = 5500
    to_port          = 5500
    protocol         ="tcp"
    self            = true
    cidr_blocks      = ["10.1.0.0/16"]
   }
   ingress {
    from_port        = 1433
    to_port          = 1433
    protocol         ="tcp"
    self            = true
    cidr_blocks      = ["10.1.0.0/16"]
   }
   ingress {
    from_port        = 4333
    to_port          = 4333
    protocol         ="tcp"
    self            = true
    cidr_blocks      = ["10.1.0.0/16"]
   }
   ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         ="tcp"
    self            = true
    cidr_blocks      = ["10.1.0.0/16"]
   }
  
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

resource "aws_security_group_rule" "example" {
   
  ingress {
      cidr_blocks      = ["10.1.0.0/16"]
    security_group_id = "aws_security_group.allow_tls.id"      
    type              = "ingress"
    from_port        = 5432
    to_port          = 5432
    protocol         ="tcp"
    self            = true
   }
 ingress {
     cidr_blocks      = ["10.1.0.0/16"]
    security_group_id = "aws_security_group.allow_tls.id"   
    type              = "ingress"
    from_port        = 3306
    to_port          = 3306
    protocol         ="tcp"
    self            = true
  }
}
