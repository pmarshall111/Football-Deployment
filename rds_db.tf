//https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

// creating private subnet for rds instance
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
//resource "aws_subnet" "rds-private1" {
//  vpc_id     = aws_default_vpc.default.id
//  cidr_block = "172.31.48.0/20"
//  availability_zone = "eu-west-2a"
//
//  tags = {
//    Name = "terraform-private-subnet"
//  }
//}
//resource "aws_subnet" "rds-private2" {
//  vpc_id     = aws_default_vpc.default.id
//  cidr_block = "172.31.64.0/20"
//  availability_zone = "eu-west-2b"
//
//  tags = {
//    Name = "terraform-private-subnet"
//  }
//}
//resource "aws_route_table" "rds-private" {
//  vpc_id = aws_default_vpc.default.id
//  tags = {
//    Name = "terraform-private-subnet-route-table"
//  }
//}
//
//resource "aws_route_table_association" "rds-private1" {
//  subnet_id      = aws_subnet.rds-private1.id
//  route_table_id = aws_route_table.rds-private.id
//}
//resource "aws_route_table_association" "rds-private2" {
//  subnet_id      = aws_subnet.rds-private2.id
//  route_table_id = aws_route_table.rds-private.id
//}
//
//resource "aws_db_subnet_group" "rds-private-group" {
//  name       = "rds private subnet group"
//  subnet_ids = [aws_subnet.rds-private1.id, aws_subnet.rds-private2.id]
//
//  tags = {
//    Name = "terraform"
//  }
//}

resource "aws_security_group" "rds-security-group" {
  name = "terraform-rds-sg"

  description = "RDS (terraform-managed)"
  vpc_id      = aws_default_vpc.default.id

//  # Only MySQL in
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_group.id]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds-football" {
  allocated_storage    = 10
  engine               = "mariadb"
  engine_version       = "10.5.12"
  instance_class       = "db.t2.micro"
  name                 = "football_betting"
  username             = var.db_username
  password             = var.db_password
  vpc_security_group_ids = [aws_security_group.rds-security-group.id]

  tags = {
    Name = "terraform-rds-football"
  }
}