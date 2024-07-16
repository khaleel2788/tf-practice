variable "network_cidr" {
// single vnet also you can include in list of string
    type = list(string)
    default = ["10.0.0.0/16"]  
}

variable "subnet_names" {
    type = list(string)
    default = [ "web", "app", "db" ]
}

variable "private_endpoint_subnet" {
    type = string
    default = "db"
}


