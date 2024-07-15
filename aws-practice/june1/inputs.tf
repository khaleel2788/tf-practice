variable "region" {
    type    = string
    default = "ap-southeast-1"
}

variable "network_cidr" {
    type    = string
    default = "10.0.0.0/16"
} 

variable "subnet_name_tags" {
    type    = list(string)
    default = [ "web1", "web2", "app1", "app2", "db1", "db2" ]
}

variable "bucket_name" {
    type    = string
    default = "kps3khaleeltf3"
}

variable "public_subnet" {
  type      = list(string)
  default   = [ "web1", "web2" ] 
}

variable "db_subnets" {
    type    = list(string)
    default = [ "db1", "db2" ]  
}

# variable "appserver_ami_id" {
#     type = string
#     default = "ami-0750a20e9959e44ff"
# }

# variable "appserver_instance_type" {
#     type = string
#     default = "t2.micro"
  
# }

# variable "webserver_ami_id" {
#     type = string
#     default = "ami-0750a20e9959e44ff"
# }

variable "keypath" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "appserver_info" {
    type                 = object({
      ami_id             = string 
      instance_type      = string
      name               = string
      public_ip_enabled  = bool
      count              = number
      subnets            = list(string)
    })
    default              = {
        ami_id           = "ami-0750a20e9959e44ff"
        instance_type    = "t2.micro"
        name             = "appserver"
        public_ip_enable = false
        count            = 2
        subnets          = ["app1", "app2"]
    } 
}

variable "webserver_info" {
    type                 = object({
      ami_id             = string 
      instance_type      = string
      name               = string
      public_ip_enabled  = bool
      count              = number
      subnets            = list(string)
    })
    default              = {
        ami_id           = "ami-0750a20e9959e44ff"
        instance_type    = "t2.micro"
        name             = "webserver"
        public_ip_enable = true
        count            = 2
        subnets          = ["web1", "web2"]
    } 
}