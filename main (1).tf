# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
}


resource "aws_instance" "ec2test" {
   
    ami = "ami-0cff7528ff583bf9a"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    tags = {
    Name = "instance2"
  }
}

resource "aws_kms_key" "my_kms_key" {
  description         = "My KMS Keys for Data Encryption"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled               = true
  enable_key_rotation      = true
  tags = {
    Name = "my_kms_key"
  }

}

data "aws_kms_key" "enc_key" {
 key_id = aws_kms_key.my_kms_key.id
}

resource "aws_ebs_volume" "data-vol" {
 availability_zone = "us-east-1a"
 size = 1
 encrypted = true
 kms_key_id =data.aws_kms_key.enc_key.arn
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
 

  tags = {
    Name = "Encryption check for snapshot"
  }
}


 
