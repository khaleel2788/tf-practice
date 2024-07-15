// lets create 2 ubuntu instances

resource "aws_key_pair" "keypair" {
    key_name = "terraform"
    public_key = file("~/.ssh/id_rsa.pub")
    depends_on = [ 
        aws_db_instance.database
     ]
}

resource "aws_instance" "appserver" {
    // in inputs variables we have mentioned type so no need to use below format
    # count = lookup(var.appserver_info, "count", 0)
    # ami   = lookup(var.appserver_info, "ami_id", "")
    # associate_public_ip_address = lookup(var.appserver_info, "public_ip_enabled", false)
    # instance_type = lookup(var.appserver_info, "instance_type", "t2.micro")
    count                           = var.appserver_info.count
    ami                             = var.appserver_info.ami_id
    associate_public_ip_address     = var.appserver_info.public_ip_enabled
    instance_type                   = var.appserver_info.instance_type
    tags = {
      Name = format("%s-%d", lookup(var.appserver_info, "name", "t2.micro"), count.index+1)
    }
    key_name    = aws_key_pair.keypair.key_name
    subnet_id = data.aws_subnets.app_subnets.ids[count.index]
    vpc_security_group_ids = [aws_security_group.appsg.id]
}