# Configure the AWS Provider
provider "aws" {
  region     = "us-west-2"
  
}

resource "aws_s3_bucket" "s3bucketsentnidhi" {
  bucket = "s3bucketsentnidhi"
  tags = {
    Name        = "My bucketone"
    Environment = "Trial"
  }
}
resource "aws_s3_bucket_public_access_block" "s3bucketsentnidhi" {
  bucket = aws_s3_bucket.s3bucketsentnidhi.id
  block_public_acls   = false

}
