# this will be used in provider.tf
variable "target_region" {
    type        = string
    default     = "ap-south-1"
    description = "region where the infra can be creared"
}
# it will be used in network.tf
variable "vpc_cidr_range" {
    type            = string
    default         = "192.168.0.0/16"
    #if don't give default in vpc it will ask for vpc range as "enter a value: 192.168.0.0/16(type here) -> try it once"
    description     = "cidr range of vpc" 
} 
