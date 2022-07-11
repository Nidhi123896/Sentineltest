provider "aws"{
  region= "us-west-2"
}
resource "aws_vpc" "vpcsg" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "mainone" {
  vpc_id     = aws_vpc.vpcsg.id
  cidr_block = "10.0.1.0/24"
  availability_zone ="us-west-2b"
  tags = {
    Name = "subnet1"
  }
}
resource "aws_subnet" "maintwo" {
  vpc_id     = aws_vpc.vpcsg.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2d"
  tags = {
    Name = "subnet2"
  }
}
resource "aws_autoscaling_group" "bar" {
  name                      = "foobar3-terraform-test"
  availability_zones = ["us-west-2b","us-west-2d"]
  max_size                  = 1
  min_size                  = 0
  launch_configuration       = aws_launch_configuration.as_conf.name
}
resource "aws_launch_configuration" "as_conf" {
  image_id      = "ami-0d70546e43a941d70"
  instance_type = "t2.micro"
}



