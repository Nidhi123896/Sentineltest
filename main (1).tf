# Configure the AWS Provider
provider "aws" {
  region     = "us-west-2"
}

resource "aws_instance" "ec2test" {
   
    ami = "ami-0ca285d4c2cda3300"
    availability_zone = "us-west-2a"
    instance_type = "t2.micro"
    tags = {
    Name = "instance1"
  }
}
resource "aws_kms_key" "ebs_encryption" {
    enable_key_rotation = true
 }

resource "aws_ebs_volume" "data-vol" {
 availability_zone = "us-west-2a"
 size = 1
 kms_key_id = aws_kms_key.ebs_encryption.arn
 tags = {
    Name = "Encryption check for volume"
  }
}
resource "aws_volume_attachment" "vol" {

 device_name = "/dev/sdc"
 volume_id = aws_ebs_volume.data-vol.id
 instance_id = aws_instance.ec2test.id
}
resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_ebs_volume.data-vol.id
  kms_key_id = "kmsKeyId"
  encrypted= true
  tags = {
    Name = "Encryption check for snapshot"
  }
}


 
