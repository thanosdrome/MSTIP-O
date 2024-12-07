resource "aws_instance" "web" {
  ami           = "ami-0614680123427b75e"
  instance_type = "t3.micro"

  tags = {
    Name = "MSTIP"
  }
}