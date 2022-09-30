# creating s3 bucket in singapore region 
variable "region" {
    type      = string
    default   = "ap-southeast-1"
}

variable "az_a" {
    type      = string
    default   = "ap-southeast-1a"
}
variable "az_b" {
    type      = string
    default   = "ap-southeast-1b"
}

variable "netwrok_cidr" {
    type      = string
    default   = "10.10.0.0/16"
}

variable "subnets_cidrs" {
    type      = list(string)
    default   = [ "10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24", "10.10.4.0/24" ]
}

variable "bucket_name" {
    type      = string
    default   = "kps3bucket"
}