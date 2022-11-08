provider "aws" {
    region = "eu-west-1"
}

variable "cloud_name" {
    type = string
    default = "Chmura_testowa"
}

variable "input_name" {
    type = string
    description = "Set the name of project"
  
}

output "vpc_id" {
    value = aws_vpc.vpc_name.id
}

#Do czego słuźy zmienna vpc_name. Jest niezbędna, ale jej nazwa nie jest nigdzie wpisywana
resource "aws_vpc" "vpc_name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        terraform = "true"
        Name = "VPC_${var.cloud_name}"
}
}