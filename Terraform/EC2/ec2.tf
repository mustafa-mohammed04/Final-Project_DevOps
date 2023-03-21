
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
resource "aws_instance" "EC2" {
  ami           = "ami-0557a15b87f6559cf" 
  instance_type = "t2.micro"
  subnet_id = "${aws_default_subnet.default_az1.id}"
  key_name                    = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name


  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true

  }
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
  description = "Allow HTTP and SSH traffic via Terraform"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
