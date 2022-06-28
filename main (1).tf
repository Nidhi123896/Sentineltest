# Configure the AWS Provider
provider "aws" {
  region     = "us-west-2"
}

resource "aws_instance" "ec2testtf" {
    ami = "ami-0ca285d4c2cda3300"
    instance_type = "t2.micro"
}
resource "aws_ebs_volume" "data-vol" {
 availability_zone = "us-west-2a"
 size = 1
}
resource "aws_volume_attachment" "vol" {
 device_name = "/dev/sdc"
 volume_id = aws_ebs_volume.data-vol.id
 instance_id = aws_instance.inst.id
}
resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_ebs_volume.data-vol.id
}
