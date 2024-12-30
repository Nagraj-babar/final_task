provider "aws" {
  region = "ap-south-1"
}

# Generate an SSH key pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create an AWS key pair resource
resource "aws_key_pair" "generated_key" {
  key_name   = "generated_key"
  public_key = tls_private_key.example.public_key_openssh
}

# Create a security group that allows inbound traffic only on port 80
resource "aws_security_group" "allow_http_inbound" {
  name        = "allow_http_inbound"
  description = "Allow inbound traffic on port 80"

  ingress {
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
    Name = "allow_http_inbound"
  }
}

# Create two EC2 instances and associate them with the security group
resource "aws_instance" "webserver" {
  count         = 2
  ami           = "ami-08048b042dd26bddb"  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_http_inbound.id]

  tags = {
    Name = "webserver-instance-${count.index + 1}"
  }
}

# Output the private key
output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}
