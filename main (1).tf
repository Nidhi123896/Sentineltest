provider "aws" {
  region = "us-east-1"
}
resource "aws_iam_user_policy" "lb_ro" {
  name = "test"
  user = aws_iam_user.user_name.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
     {
      "Action":  "iam:*",
      "Effect": "Allow",
      "Resource": "*"
    }
    ]
  })
}

resource "aws_iam_user" "user_name" {
  name = "testuser"
  path = "/"
}


resource "aws_iam_role" "role" {
  name = "managedpolicy"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action":  "iam:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_group" "group" {
  name = "group_policy"
}

resource "aws_iam_group_policy" "group_pol" {
  name = "test"
  user = aws_iam_group.group.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
     {
      "Action":  "iam:*",
      "Effect": "Allow",
      "Resource": "*"
    }
    ]
  })
}



resource "aws_iam_policy" "policy" {
  name        = "root"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action":  "iam:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


