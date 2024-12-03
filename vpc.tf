provider "aws" {
  region  = "us-west-1"
  profile = "my-dev-profile"
}

resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "App-VPC"
  }
}

resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-1b"
  tags = {
    Name = "App-Subnet"
  }
}

resource "aws_internet_gateway" "app_gw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "App-Internet-Gateway"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH access to the bastion host"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this to your IP for better security
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BastionSecurityGroup"
  }
}

resource "aws_security_group" "elasticache_access_sg" {
  name        = "elasticache-access-sg"
  description = "Allow access to ElastiCache from bastion"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    description     = "Allow Redis traffic from Bastion"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ElastiCacheAccessSecurityGroup"
  }
}
# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_gw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associate Subnet with Public Route Table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_elasticache_subnet_group" "app_subnet_group" {
  name        = "app-cache-subnet-group"
  description = "Subnet group for App ElastiCache"
  subnet_ids  = [aws_subnet.app_subnet.id] # Subnet from your custom VPC

  tags = {
    Name = "AppCacheSubnetGroup"
  }
}
