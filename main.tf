terraform {
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata.yaml")
}

data "aws_vpc" "main" {
  default = true
}

data "aws_ami" "Amazon_Linux_2_Default" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "description"
    values = ["Amazon Linux 2023 AMI*"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*x86_64"]
  }
}

resource "aws_key_pair" "dev-key" {
  key_name   = "dev-key"
  public_key = var.public_key

}

resource "aws_security_group" "sg_my_server" {
  name        = "sq_my_server"
  description = "My server secuirty group"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.sg_my_server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg_my_server.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.sg_my_server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}



resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.Amazon_Linux_2_Default.id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.dev-key.key_name
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data              = data.template_file.user_data.rendered

  tags = {
    Name = var.server_name
    Orign = "Terraform"
  }
}

