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
  cidr_block          = var.web1_cidr_range
  availability_zone   = var.web1_az
  
       tags           = {
       Name           = "web1-tf"
  }
}

resource "aws_subnet" "web2" {
  vpc_id              = aws_vpc.myvpc.id
  cidr_block          = var.web2_cidr_range
  availability_zone   = var.web2_az

        tags          = {
        Name          = "web2-tf"
  }
}

resource "aws_subnet" "db1" {
  vpc_id              = aws_vpc.myvpc.id
  cidr_block          = var.db1_cidr_range
  availability_zone   = var.db1_az

       tags           = {
       Name           = "db1-tf"
  }
}

resource "aws_subnet" "db2" {
  vpc_id              = aws_vpc.myvpc.id
  cidr_block          = var.db2_cidr_range
  availability_zone   = var.db2_az

         tags         = {
         Name         = "db2-tf"
  }
}
