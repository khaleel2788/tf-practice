# AWS
resource "aws_instance" "app" {
    instance_type      = "t2micro"
    ami                = "ami-892347389247"
    availability_zone  = "us-west-2a"
}
#AZURE
resource "azure_vm" "app" {
    size     = "Standard_B1s"
    vmimage  = "ubuntu2004LTS"
    location = "eastus"
}

#vmware
resource "vmware_vm" "app" {
    cpu    = "2"
    ram    = "4GB"
    image  = "ubuntu"


}