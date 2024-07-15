resource "aws_vpc" "ntier" {
    cidr_block = var.network_cidr
    tags       = {
        Name   = "ntier"
    }
}

// for (i=0 ; i < 6 ; i++){
// resource "aws_subnet" "subnet" {
//    cidr_block        = var.subnet_cidr[i]
//    availability_zone = var.subnet_azs[i]
//    vpc_id           = aws_vpc.ntier.id
//      tags           = {
//      Name           = var.subnet_name_tags[i]
//     }       
//   }
// }

resource "aws_subnet" "subnets" {
    count        = length(var.subnet_name_tags)
    cidr_block   = cidrsubnet(var.subnet_cidr,8,count.index)
    tags         = {
        Name     = var.subnet_name_tags[count.index]
    }
    availability_zone = format("${var.region}%s", count.index%2==0?"a":"b")
    vpc_id            = aws_vpc.ntier.id
}

resource "aws_internet_gateway" "ntier_igw" {
    vpc_id      = aws_vpc.ntier.id
    tags        = {
        Name    = "ntier-igw"
    }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket      = var.bucket_name  
}

resource "aws_security_group" "websg" {
// ingress is for incoming ports
// egress is for outgoing ports 
vpc_id              = aws_vpc.ntier.id
description         = local.default_description

ingress {
    from_port           = local.ssh_port
    to_port             = local.ssh_port
    protocol            = local.tcp
    cidr_blocks         = [local.any_where]
}

ingress {
    from_port           = local.http_port
    to_port             = local.http_port
    protocol            = local.tcp
    cidr_blocks         = [local.any_where]
}

egress {
    from_port           = local.all_ports
    to_port             = local.all_ports
    protocol            = local.any_protocol
    cidr_blocks         = [local.any_where]
    ipv6_cidr_blocks    = [local.any_where_ip6]
  }
tags = {
  Name                  = "websecurity group"
}   

resource "aws_security_group" "appsg" {
// ingress is for incoming ports
// egress is for outgoing ports 
vpc_id              = aws_vpc.ntier.id
description         = local.default_description

ingress {
    from_port           = local.ssh_port
    to_port             = local.ssh_port
    protocol            = local.tcp
    cidr_blocks         = local.any_where
}

ingress {
    from_port           = local.db_port
    to_port             = local.db_port
    protocol            = local.tcp
    cidr_blocks         = [var.network_cidr]
}

egress {
    from_port           = local.all_ports
    to_port             = local.all_ports
    protocol            = local.any_protocol
    cidr_blocks         = [local.any_where]
    ipv6_cidr_blocks    = [local.any_where_ip6]
  }
tags = {
  Name                  = "app security group"
}   
}

resource "aws_security_group" "dbsg" {
// ingress is for incoming ports
// egress is for outgoing ports 
vpc_id              = aws_vpc.ntier.id
description         = local.default_description

ingress {
    from_port           = local.ssh_port
    to_port             = local.ssh_port
    protocol            = local.tcp
    cidr_blocks         = local.any_where
}

ingress {
    from_port           = local.app_port
    to_port             = local.app_port
    protocol            = local.tcp
    cidr_blocks         = [var.network_cidr]
}

egress {
    from_port           = local.all_ports
    to_port             = local.all_ports
    protocol            = local.any_protocol
    cidr_blocks         = [local.any_where]
    ipv6_cidr_blocks    = [local.any_where_ip6]
  }
tags = {
  Name                  = "db security group"
}   
}


resource "aws_route_table" "publicrt" {
  vpc_id                = aws_vpc.ntier.id 
  route {
    cidr_block          = local.any_where
     gateway_id = aws_internet_gateway.ntier_igw.id
  }
  tags                  = {
    Name                = "public rt"
  } 
}

resource "aws_route_table" "privatert" {
  vpc_id                = aws_vpc.ntier.id 
  
  tags                  = {
    Name                = "private rt"
  } 
}

// Route table can be associated in 2 given ways:
// resource "aws_route_table_association" "association" {
//    count               = length(aws_subnet.subnets)
//    subnet_id           = aws_subnet.subnets[count.index].id
//    route_table_id  = count.index<2 ? aws_route_table.public.id : aws_route_table.privatert.id
// }

resource "aws_route_table_association" "association" {
    count               = length(aws_subnet.subnets)
    subnet_id           = aws_subnet.subnets[count.index].id
    route_table_id      = contains(var.public_subnets, lookup(aws_subnet.subnets[count.index].tags_all, "Name", ""))?aws_route_table.publicrt.id : aws_route_table.privatert.id
}
