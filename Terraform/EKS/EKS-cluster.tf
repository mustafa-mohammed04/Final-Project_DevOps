# Resource: aws_iam_role

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-1"

  assume_role_policy = <<POLICY
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
POLICY
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
    endpoint_private_access = false
    endpoint_public_access = true
    subnet_ids = [
      "subnet-04ce55fb59e1ba269",
      "subnet-067af9534e031aa7b"
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]
}
