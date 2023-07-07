provider "aws" {

    region  = "us-east-1"

}

resource "aws_security_group" "tf-sg-apache" {

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol         = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
} 

resource "tls_private_key" "demo_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "demo_key_pair" {
  key_name   = "sample_key"
  public_key = tls_private_key.demo_key.public_key_openssh
  
  provisioner "local-exec" {
    command = "echo '${tls_private_key.demo_key.private_key_pem}' > ./sample_key.pem"
  }
}

data "aws_ami" "amzlinux" {
    most_recent = true
    

    filter {
      name = "name"
      values = ["al2023-ami-2023.0.20230419.0-kernel-6.1-x86_64"]
    }

    owners = ["137112412989"]
}

resource "aws_instance" "samplew_web" {

    ami = data.aws_ami.amzlinux.id
    instance_type = "t2.micro"
    #instance_type =  var.instance_type
    vpc_security_group_ids = [aws_security_group.tf-sg-apache.id]
    key_name = aws_key_pair.demo_key_pair.key_name
    user_data = file("apache_install.sh")
  
}

