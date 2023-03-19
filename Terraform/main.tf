module "EKS" {
  source = "./EKS"

}

module "Ec2" {
  source = "./EC2"

}

module "ECR" {
  source = "./ECR"

}