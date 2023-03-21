# Resource: aws_iam_role
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-1b"

  tags = {
    Name = "Default subnet for us-east-1b"
  }
}
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-1"
  path = "/"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  role = aws_iam_role.eks_cluster.name
}

# Resource: aws_eks_cluster

resource "aws_eks_cluster" "eks" {
  name = "sprints-eks"

  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = [aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id]
  }

  depends_on = [
    aws_iam_role.eks_cluster
  ]
}
