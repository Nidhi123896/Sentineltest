provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "mainvpc" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 445
    to_port          = 445
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
    
   
  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
   
  }




  tags = {
    Name = "allowtls"
  }
}
