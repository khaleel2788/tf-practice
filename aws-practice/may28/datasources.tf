data "aws_subnets" "db_subnets" {
    filter {
        name    = "tag:Name"
        values  = var.db_subnets
    }  
    filter {
        name    = "vpc_id"
        values  = [aws_vpc.ntier.id]
    }  
}