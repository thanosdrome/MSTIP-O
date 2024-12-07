resource "aws_vpc" "MSTIPvpc" {
 cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.MSTIPvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
    vpc_id = aws_vpc.MSTIPvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.MSTIPvpc.id
}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.MSTIPvpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.RT.id
  
}

resource "aws_route_table_association" "rta2" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.RT.id
  
}

resource "aws_security_group" "webSg" {
  name        = "web"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.MSTIPvpc.id

   ingress {
    description     = "HTTP from VPC"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "mstip-bucket-12-2024"
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}



resource "aws_instance" "webserver1" {
    ami = "ami-053b12d3152c0cc71"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.webSg.id]
    subnet_id = aws_subnet.sub1.id
    user_data = base64encode(file("userdata.sh"))
  
}
resource "aws_instance" "webserver2" {
    ami = "ami-053b12d3152c0cc71"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.webSg.id]
    subnet_id = aws_subnet.sub2.id
    user_data = base64encode(file("userdata2.sh"))
  
}