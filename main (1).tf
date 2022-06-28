# Configure the AWS Provider
provider "aws" {
  region     = "us-west-2"
}

resource "aws_instance" "ec2testtf" {
    ami = "ami-0ca285d4c2cda3300"
    instance_type = "t2.micro"
}
