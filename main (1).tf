# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
}

resource "aws_kms_key" "my_kms_key" {
  description         = "My KMS Keys for Data Encryption"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled               = true
  enable_key_rotation      =true  

  tags = {
    Name = "my_kms_key"
  }

  policy = <<EOF
{
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::390132021439:user/chandraaws539"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::390132021439:user/chandraaws539"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_kms_alias" "my_kms_alias" {
  target_key_id = aws_kms_key.my_kms_key.key_id
  name          = "alias/${var.kms_alias}"
}

output "key_id" {
  value = aws_kms_key.my_kms_key.key_id
}
