# Main VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = local.main_vpc_cidr_block
  tags = {
    task = "s3-bucket-listing"
    Name = "main-vpc"
  }
}

# Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    task = "s3-bucket-listing"
    Name = "main-igw"
  }
}

# Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = local.public_subnet_cidr_block
  availability_zone       = local.availability_zone_1
  map_public_ip_on_launch = true
  tags = {
    task = "s3-bucket-listing"
    Name = "public-subnet-1"
  }
}

# Route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    task = "s3-bucket-listing"
    Name = "public-route-table"
  }
}

# Attaching route tables with subnet
resource "aws_route_table_association" "public_rt_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
}

# Security group
resource "aws_security_group" "public_instance_sg" {
  name   = "public_instance_sg"
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    task = "instances"
    Name = "public_instance_sg"
  }
}
