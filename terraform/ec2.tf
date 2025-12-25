resource "aws_key_pair" "my_key" {
    key_name = "My-Mega-key"
    public_key = file("${path.module}/keys/mega_key.pub")
}

resource "aws_default_vpc" "my_vpc" {
  
}

resource "aws_security_group" "my_sg" {
  name        = "My-Mega-sg"
  description = "Allow ssh & http"
  vpc_id      = aws_default_vpc.my_vpc.id

  tags = {
    Name = "allow-ssh-${var.my_env}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_rule" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_rule" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_ingress_rule" "http_rule" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "m7i-flex.large"
  key_name = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_sg.name]
  root_block_device {
    volume_size = var.my_env == "prd" ? 15 : 10
    volume_type = "gp3"
  }
  user_data = file("${path.module}/install_tools.sh")

  tags = {
    Name = "my_mega_instance"
    Environment = var.my_env
  }
}
