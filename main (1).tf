provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "my_kms_key" {
  description         = "My KMS Keys for Data Encryption" #The description of the key as viewed in AWS console.
  customer_master_key_spec = "SYMMETRIC_DEFAULT" # Default encryption; can be symmetric or asymmetric
  enable_key_rotation      = true # Specifies whether key rotation is enabled. Defaults to false.
  
  tags = {
    Name = "my_kms_key"
  }
