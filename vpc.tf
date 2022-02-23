# Creating VPC,name, CIDR and Tags
resource "aws_vpc" "dev" {
  cidr_block           = "${var.vpc-cidr}"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "dev"
  }
}
# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "dev-gw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev IGW"
  }
}
# Creating Public Subnets in VPC
resource "aws_subnet" "dev-public-1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "${var.public-subnet-1-cird}"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public-1"
  }
}
# Creating Private Subnets in VPC
resource "aws_subnet" "dev-private-1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "${var.public-subnet-1-cird"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1"

  tags = {
    Name = "dev-private-1"
  }
}

# Creating Route Tables for Internet gateway
resource "aws_route_table" "dev-public" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "aws_internet_gateway.dev-gw.id"
  }

  tags = {
    Name = "dev-public route aws_route_table-1"
  }
}
# Creating Route Associations public subnets
resource "aws_route_table_association" "dev-public-1-a" {
  subnet_id      = aws_subnet.dev-public-1.id
  route_table_id = aws_route_table.dev-public.id
}
# Creating Route Associations private subnets
resource "aws_route_table" "dev-private" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "aws_internet_gateway.dev-gw.id"
  }

  tags = {
    Name = "dev-private route aws_route_table-1"
  }
}
# Creating Route Associations private subnets
resource "aws_route_table_association" "dev-private-1-a" {
  subnet_id      = aws_subnet.dev-private-1.id
  route_table_id = aws_route_table.dev-private.id


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.dev.cidr_block]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow https inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.dev.cidr_block]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow_http"
  }
}
resource "aws_security_group" "allow_https" {
  name        = "allow_http"
  description = "Allow https inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description      = "https from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.dev.cidr_block]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow_https"
  }
}
#create load balancer
resource "aws_elb" ""aws_vpc" "dev" {
  name               = ""aws_vpc" "dev"
  availability_zones = ["us-east-1a"]

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
    ssl_certificate_id = "arn:aws:iam::000000000000:server-certificate/wu-tang.net"
  }

  tags = {
    Name = ""aws_vpc" "dev"
  }
} 


resource "aws_elb" ""aws_vpc" "dev" {
  name               = ""aws_vpc" "dev"
  availability_zones = ["us-east-1a"]

  listener {
    instance_port      = 443
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::000000000000:server-certificate/wu-tang.net"
  }

  tags = {
    Name = ""aws_vpc" "dev"
  }
}