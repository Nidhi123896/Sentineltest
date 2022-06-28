# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "ec2" {
  ami               = "ami-5b673c34"
  instance_type     = "t2.micro"
}
resource "aws_ebs_volume" "data-vol" {

 size = 1


}

resource "aws_volume_attachment" "vol" {
 device_name = "/dev/sdc"
 volume_id = aws_ebs_volume.data-vol.id
 instance_id = aws_instance.ec2.id
}
resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_ebs_volume.data-vol.id

  
}
