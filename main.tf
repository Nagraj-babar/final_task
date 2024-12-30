provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "webserver" {
  count         = 2
  ami           = "ami-08048b042dd26bddb"  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"

  tags = {
    Name = "webserver-instance-${count.index + 1}"
  }
}
