resource "aws_instance" "EC2" {
  ami           = "ami-0557a15b87f6559cf" 
  instance_type = "t2.micro"
  key_name                    = aws_key_pair.key.key_name
  vpc_security_group_ids      = ["${aws_security_group.sg.id}"]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile_jenkins-2.name


  tags = {
    Name = "EC2-Jenkins-by-terraform"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]


}


resource "tls_private_key" "pk" {
     algorithm = "RSA"
     rsa_bits = 4096
 }

resource "aws_key_pair" "key" {
   key_name   = "key_pair-jenkinskey"
   public_key = tls_private_key.pk.public_key_openssh

   provisioner "local-exec" {
     command = "echo '${tls_private_key.pk.private_key_pem}' > ~/key_pair.pem"
   }
 }
 
resource "aws_security_group" "sg" {
  name        = "jenkins-sg"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

    ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

    ingress {
    from_port        = 50000
    to_port          = 50000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

}
