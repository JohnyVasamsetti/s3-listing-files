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
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = local.public_subnet_cidr_block_1
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
resource "aws_route_table_association" "public_rt_1_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_1.id
}
