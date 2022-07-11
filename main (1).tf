provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "vpcsg" {
  cidr_block = "10.0.0.0/16"
  
}
resource "aws_subnet" "mainone" {
  vpc_id     = aws_vpc.vpcsg.id
  cidr_block = "10.0.1.0/24"
  
  availability_zone ="us-east-1c"
 
  tags = {
    Name = "subnet1"
  }
}
resource "aws_subnet" "maintwo" {
  vpc_id     = aws_vpc.vpcsg.id
  cidr_block = "10.0.2.0/24"
 
  availability_zone = "us-east-1d"
  tags = {
    Name = "subnet2"
  }
}

resource "aws_security_group" "allow_tlss" {
  name        = "allow"
  description = "Allow TLS inbound traffic"
 vpc_id      = aws_vpc.vpcsg.id
  
  tags = {
    Name = "ingress"
  }
}


resource "aws_instance" "my-ec2" {
  ami ="ami-087c17d1fe0178315"
  instance_type = "t2.micro"
 
  #role= "aws_iam_role.EC2S3TF1.name"
  #iam_instance_profile = [aws_iam_instance_profile.EC2S3TF1.name]
  vpc_security_group_ids = ["${aws_security_group.allow_tlss.id}"]
   subnet_id = aws_subnet.maintwo.id
  tags = {
    ec2_create = "instance1"
  }
}





resource "aws_security_group_rule" "rule1" {
  type              = "ingress"
  from_port         = 1434
  to_port           = 1434
  protocol          = "udp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule2" {
  type              = "ingress"
  #self              = true
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule3" {
  type              = "ingress"
  #self              = true
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule4" {
  type              = "ingress"
  #self              = true
  from_port         = 4333
  to_port           = 4333
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule5" {
  type              = "ingress"
  #self              = true
  from_port         = 1433
  to_port           = 1433
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule6" {
  type              = "ingress"
  #self              = true
  from_port         = 5500
  to_port           = 5500
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule7" {
  type              = "ingress"
  #self              = true
  from_port         = 445
  to_port           = 445
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule8" {
  type              = "ingress"
  #self              = true
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}
resource "aws_security_group_rule" "rule9" {
  type              = "ingress"
  #self              = true
  from_port         = 135
  to_port           = 135
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}

resource "aws_security_group_rule" "rule10" {
  type              = "ingress"
  #self              = true
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}

resource "aws_security_group_rule" "rule11" {
  type              = "ingress"
  #self              = true
  from_port         = 23
  to_port           = 23
  protocol          = "tcp"
  cidr_blocks       = ["10.1.0.0/16"]
  security_group_id = aws_security_group.allow_tlss.id
}





# This policy uses the Sentinel tfplan/v2 import to validate that no security group
# rules have the CIDR "0.0.0.0/0" for ingress rules.  It covers both the
# aws_security_group and the aws_security_group_rule resources which can both
# define rules.

# Import the tfplan/v2 import, but use the alias "tfplan"
import "tfplan/v2" as tfplan

# Import common-functions/tfplan-functions/tfplan-functions.sentinel
# with alias "plan"
import "tfplan-functions" as plan

# Forbidden CIDRs
# Include "null" to forbid missing or computed values
forbidden_cidrs = ["0.0.0.0/0"]

# Get all Security Group Ingress Rules
SGIngressRules = filter tfplan.resource_changes as address, rc {
  rc.type is "aws_security_group_rule" and
  rc.mode is "managed" and
  (rc.change.actions contains "create" or   rc.change.actions contains "update" or
   rc.change.actions contains "read" or rc.change.actions contains "no-op") and
  rc.change.after.type is "ingress" 
}

# Filter to Ingress Security Group Rules with violations
# Warnings will be printed for all violations since the last parameter is true
violatingSGRules = plan.filter_attribute_contains_items_from_list(SGIngressRules,
                  "cidr_blocks",forbidden_cidrs, true)

# Get all Security Groups
allSGs = plan.find_resources("aws_security_group")

# Validate Security Groups
violatingSGsCount = 0
for allSGs as address, sg {

  # Find the ingress rules of the current SG
  ingressRules = plan.find_blocks(sg, "ingress")

  # Filter to violating CIDR blocks
  # Warnings will not be printed for violations since the last parameter is false
  violatingIRs = plan.filter_attribute_contains_items_from_list(ingressRules,
                 "cidr_blocks", forbidden_cidrs, false)

  # Print violation messages
  if length(violatingIRs["messages"]) > 0 {
    violatingSGsCount += 1
    print("SG Ingress Violation:", address, "has at least one ingress rule",
          "with forbidden cidr blocks")
    plan.print_violations(violatingIRs["messages"], "Ingress Rule")
  }  // end if

} // end for SGs

# Main rule
validated = length(violatingSGRules["messages"]) is 0 and violatingSGsCount is 0
main = rule {
  validated is true
}
