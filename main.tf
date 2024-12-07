resource "aws_vpc" "MSTIPvpc" {
 cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.MSTIPvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    map_customer_owned_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
    vpc_id = aws_vpc.MSTIPvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1b"
    map_customer_owned_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.MSTIPvpc.id
    
  
}