resource "aws_subnet_group" "db_subnets_group" {
    name                = "ntier-db-subnet-group"
    subnet_ids          = data.aws_subnet_ids.db_subnet_ids.ids
}