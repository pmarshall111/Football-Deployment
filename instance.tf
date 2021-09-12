variable "my-IP" {
  default = "82.0.226.196"
}

variable "sec_group_name" {
  default = "EC2 home SSH HTTP"
}

variable "key_name" {
  default = "Dell Ubuntu 20.04 LTS"
}

resource "aws_security_group" "ec2_group" {
  ingress {
    from_port = 22
    protocol = "TCP"
    to_port = 22
    cidr_blocks = ["${var.my-IP}/32"]
  }

  ingress {
    from_port = 80
    protocol = "TCP"
    to_port = 80
    cidr_blocks = ["${var.my-IP}/32"]
  }

  ingress {
    from_port = 443
    protocol = "TCP"
    to_port = 443
    cidr_blocks = ["${var.my-IP}/32"]
  }

  egress {
//    allow all.yaml outbound traffic
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  name = var.sec_group_name

  tags = {
    Name = var.sec_group_name
  }
}

resource "aws_instance" "ec2_instance" {
  instance_type = "t2.micro"
  ami = "ami-096cb92bb3580c759"
  vpc_security_group_ids = [aws_security_group.ec2_group.id]
  key_name = var.key_name
  user_data = file("scripts/setup_ansible_user.sh")
  tags = {
    Name = "terraform-ec2"
  }
}

output "ec2_IP" {
  value = aws_instance.ec2_instance.public_ip
}

resource "aws_key_pair" "one_of_my_many_keys" {
  key_name = var.key_name
  public_key = file("/home/peter/.ssh/nopass.pub")
}