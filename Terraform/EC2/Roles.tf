
resource "aws_iam_role" "ec2-role" {
 name = "ec2-role"
 path = "/"
 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "ec2.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF
}
resource "aws_iam_policy" "eks-fullaccess" {
  name        = "eks-access"
  path        = "/"
  description = "Allow Full access to Kubernates cluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action: [
        "eks:*",
        "ecr:*",
      ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-fullaccess" {
  policy_arn = aws_iam_policy.eks-fullaccess.arn
  role    = aws_iam_role.ec2-role.name
 }
 

 resource "aws_iam_instance_profile" "ec2_profile"{
    name = "ec2-profile"
    role = aws_iam_role.ec2-role.name
  }

