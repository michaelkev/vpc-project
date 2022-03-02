provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}
# Creating VPC,name, CIDR and Tags
resource "aws_vpc" "dev_vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "dev_vpc"
  }
}
# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "dev IGW"
  }
}
# Creating Public Subnets in VPC
resource "aws_subnet" "dev-public-1" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "dev-public-1"
  }
}
# Creating Private Subnets in VPC
resource "aws_subnet" "dev-private-1" {
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "dev-private-1"
  }
}

# Creating Route Tables for Internet gateway
resource "aws_route_table" "dev-public_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }
  tags = {
    Name = "dev-public route"
  }
}
# Creating Route Associations public subnets
resource "aws_route_table_association" "dev_public_rta" {
  subnet_id      = aws_subnet.dev-public-1.id
  route_table_id = aws_route_table.dev-public_rt.id
}
# Creating Route Table private subnets
resource "aws_route_table" "dev-private_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.dev-natgw.id
  }

  tags = {
    Name = "dev-private route aws_route_table-1"
  }
}
# Creating Route Associations private subnets
resource "aws_route_table_association" "dev-private-1-a" {
  subnet_id      = aws_subnet.dev-private-1.id
  route_table_id = aws_route_table.dev-private_rt.id
}
resource "aws_nat_gateway" "dev-natgw" {
  subnet_id     = aws_subnet.dev-private-1.id
  allocation_id = aws_eip.dev-eip.id
}
resource "aws_eip" "dev-eip" {
  vpc = true
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.dev_vpc.id
  #
  ingress {
    description = "ssh from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow https inbound traffic"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_http"
  }
}
resource "aws_security_group" "allow_https" {
  name        = "allow_https"
  description = "Allow https inbound traffic"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "allow https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_https"
  }
}
resource "aws_instance" "webserver" {
  ami = "ami-04505e74c0741db8d"
  security_groups = [aws_security_group.allow_ssh.id]
  instance_type = "t2.micro"
  tags = {
    Name = "web_server"
  }
}
