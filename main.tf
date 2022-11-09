provider "aws" {
    region = "eu-west-1"
}

variable "cloud_name" {
    type = string
    default = "kasyan.me"
}

variable "cost_tag" {
    type = string
    description = "Enter a name for the tag prd/int/tst"
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

resource "aws_instance" "ec2" {
    ami = "ami-096800910c1b781ba"
    instance_type = "t2.micro"
    tags = {
        terraform = "true"
        Name = "Master_${var.cloud_name}"
    }
}

resource "aws_eip" "elasticeip" {
    instance = aws_instance.ec2.id
  
}

output "EIP" {
    value = aws_eip.elasticeip.public_ip
  
}