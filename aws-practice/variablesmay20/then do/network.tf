#creating TF network
resource "aws_vpc" "myvpc" {
    cidr_block  = var.vpc_cidr_range
# in the last time vpc creation we used cidr_block = 192.168.0.1/16
        tags    = {
        "Name"  = "from-tf"
        }
}

# creating TF subnets

resource "aws_subnet" "web1" {
  vpc_id              = aws_vpc.myvpc.id
  cidr_block          = "192.168.0.0/24"
  availability_zone   = "ap-south-1a"
  
       tags           = {
       Name           = "web1-tf"
  }
}

resource "aws_subnet" "web2" {
  vpc_id              = aws_vpc.myvpc.id
  cidr_block          = "192.168.1.0/24"
  availability_zone   = "ap-south-1b"

        tags          = {
        Name          = "web2-tf"
  }
}

resource "aws_subnet" "db1" {
  vpc_id              = aws_vpc.myvpc.id
  cidr_block          = "192.168.2.0/24"
  availability_zone   = "ap-south-1a"

       tags           = {
       Name           = "db1-tf"
  }
}

resource "aws_subnet" "db2" {
  vpc_id              = aws_vpc.myvpc.id
  cidr_block          = "192.168.3.0/24"
  availability_zone   = "ap-south-1b"

         tags         = {
         Name         = "db2-tf"
  }
}
