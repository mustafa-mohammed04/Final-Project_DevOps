resource "aws_iam_role" "nodes_general" {
  name = "eks-node-group-general"

assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  role = aws_iam_role.nodes_general.name
}

resource "aws_eks_node_group" "nodes_general_group" {
  cluster_name = aws_eks_cluster.eks.name

  node_group_name = "nodes-general"

  node_role_arn = aws_iam_role.nodes_general.arn


  subnet_ids = [aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id]

  instance_types = ["t3.small"]
 
  scaling_config {
   desired_size = 1
   max_size   = 1
   min_size   = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}