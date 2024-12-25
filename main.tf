resource "aws_s3_bucket" "content_storage_for_listing_assignment" {
  bucket = "content-storage-for-listing-assignment"

  tags = {
    task = "s3-listing-assignment"
  }
}

# Creating Ec2 instances
resource "aws_instance" "public_instance" {
  ami             = local.ami_id
  instance_type   = local.instance_type
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.public_instance_sg.id]
  key_name        = aws_key_pair.instance_key.key_name
  tags = {
    task = "s3-bucket-listing"
    Name = "public_instance"
  }
}

# key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "instance_key" {
  key_name   = "instance_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
resource "aws_secretsmanager_secret" "key_pair_secret" {
  name = "key_pair_secret"
}
resource "aws_secretsmanager_secret_version" "instance_key_version" {
  secret_string = tls_private_key.ssh_key.private_key_pem
  secret_id     = aws_secretsmanager_secret.key_pair_secret.id
}
