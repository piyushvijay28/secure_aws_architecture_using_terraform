# define provider and region
provider "aws" {
  region = "ap-south-1"
}

# define aws vpc
resource "aws_vpc" "practice_ec2_vpc" {
  cidr_block = var.aws_vpc_cidr

    tags = {
    Name = "Practice EC2"
  }
}

# define internet gateway in above created vpc for internet access
resource "aws_internet_gateway" "practice_ec2_ig" {
  vpc_id = aws_vpc.practice_ec2_vpc.id

    tags = {
    Name = "Practice EC2"
  }
}

# define aws elastic ip associate with ec2 instance in private subnet to have internet access using nat gateway 
resource "aws_eip" "practice_ec2_eip" {
 domain = "vpc"
 depends_on = [ aws_internet_gateway.practice_ec2_ig ]

   tags = {
    Name = "Private EC2"
  }
}

# defining public subnet in vpc
resource "aws_subnet" "practice_ec2_public_sn" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.practice_ec2_vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

# define private subnet in vpc
resource "aws_subnet" "practice_ec2_private_sn" {
  count      = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.practice_ec2_vpc.id
  cidr_block = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

# define nat gateway in first availiability zone of public subnet
resource "aws_nat_gateway" "practice_ec2_ng" {
  subnet_id = aws_subnet.practice_ec2_public_sn[0].id
  allocation_id = aws_eip.practice_ec2_eip.id
  depends_on = [ aws_internet_gateway.practice_ec2_ig ]

    tags = {
    Name = "Practice EC2"
  }
}

# creating route table to have internet access form public subnet using internet gateway
resource "aws_route_table" "practice_ec2_public_rt" {
  vpc_id = aws_vpc.practice_ec2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.practice_ec2_ig.id
  }

    tags = {
    Name = "Public EC2 RT"
  }
}

# associating routes of public subnet to public route table 
resource "aws_route_table_association" "practice_ec2_public_rt_a" {
  route_table_id = aws_route_table.practice_ec2_public_rt.id
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.practice_ec2_public_sn[*].id, count.index)
}

# creating route table for private subnet 
resource "aws_route_table" "practice_ec2_private_rt" {
  vpc_id = aws_vpc.practice_ec2_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.practice_ec2_ng.id
  }

    tags = {
    Name = "Private EC2 RT"
  }
}

# associating route table of private subnet to private route table
resource "aws_route_table_association" "practice_ec2_private_rt_a" {
    route_table_id = aws_route_table.practice_ec2_private_rt.id
    count = length(var.private_subnet_cidrs)
    subnet_id = element(aws_subnet.practice_ec2_private_sn[*].id, count.index)
}

# defining security group in vpc
resource "aws_security_group" "practice_ec2_sg" {
  name   = "practice_ec2_sg"
  vpc_id = aws_vpc.practice_ec2_vpc.id

    tags = {
    Name = "Practice EC2"
  }
}

# creating security group ingress rule
resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = aws_security_group.practice_ec2_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

# creating securtiy group ingress rule for ssh
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.practice_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# defining outbound rules
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.practice_ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# defining ec2 instance in public subnet 
resource "aws_instance" "practice_public_ec2" {
  ami                         = var.ami
  key_name                    = "practice_ec2"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.practice_ec2_public_sn[0].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.practice_ec2_sg.id]

    tags = {
    Name = "Public EC2"
  }
}

# defining ec2 instance in private subnet
resource "aws_instance" "practice_private_ec2" {
  ami = var.ami
  key_name = "practice_ec2"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.practice_ec2_private_sn[0].id
  vpc_security_group_ids = [aws_security_group.practice_ec2_sg.id]
  
    tags = {
    Name = "Private EC2"
  }
}
