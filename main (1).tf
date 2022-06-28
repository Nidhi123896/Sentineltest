# Configure the AWS Provider
provider "aws" {
  region     = "us-west-2"
}

resource "aws_instance" "inst" {
  ami               = "ami-0d08ef957f0e4722b"
  instance_type     = "t2.micro"
}

