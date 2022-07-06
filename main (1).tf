provider "aws" {
  region = "us-west-2"
}


resource "aws_vpc" "mainvpc" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 23
    to_port          = 23
    protocol         = "tcp"
    self            = true
    cidr_blocks      = [aws_vpc.mainvpc.cidr_block]
  }
   ingress {
    from_port        = 22
    to_port          = 22
    protocol         ="tcp"
    self            = true
    cidr_blocks      = [aws_vpc.mainvpc.cidr_block]
   }
   ingress {
    from_port        = 135
    to_port          = 135
    protocol         ="tcp"
    self            = true
    cidr_blocks      = [aws_vpc.mainvpc.cidr_block]
   }
   ingress {
    from_port        = 445
    to_port          = 445
    protocol         ="tcp"
    self            = true
    cidr_blocks      = [aws_vpc.mainvpc.cidr_block]
   }
   ingress {
    from_port        = 3389
    to_port          = 3389
    protocol         ="tcp"
    self            = true
    cidr_blocks      = [aws_vpc.mainvpc.cidr_block]
   }
   ingress {
    from_port        = 5500
    to_port          = 5500
    protocol         ="tcp"
    self            = true
    cidr_blocks      = [aws_vpc.mainvpc.cidr_block]
   }
   ingress {
    from_port        = 1433
    to_port          = 1433
    protocol         ="tcp"
    self            = true
    cidr_blocks      = [aws_vpc.mainvpc.cidr_block]
   }
   ingress {
    from_port        = 4333
    to_port          = 4333
    protocol         ="tcp"
    self            = true
    cidr_blocks      = [aws_vpc.mainvpc.cidr_block]
   }
   ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         ="tcp"
    self            = true
    cidr_blocks      = [aws_vpc.mainvpc.cidr_block]
   }
   ingress {
    from_port        = 5432
    to_port          = 5432
    protocol         ="tcp"
    self            = true
    cidr_blocks      = [aws_vpc.mainvpc.cidr_block]
   }
   ingress {
    from_port        = 1434
    to_port          = 1434
    protocol         ="udp"
    self            = true
    cidr_blocks      = [aws_vpc.mainvpc.cidr_block]
   }
    tags = {
    Name = "ingressrule"
  }
}


resource "aws_instance" "my-ec2" {
  ami = "ami-0ca285d4c2cda3300"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.allow_tls.name}"]
}

