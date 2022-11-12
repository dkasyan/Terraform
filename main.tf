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

variable "ingressrules" {
  type = list(number)
  default = [80, 443 ]
}

variable "engresrules" {
  type = list(number)
  default = [80, 443, 8080 ]
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





#Iterator w dynamic block
resource "aws_security_group" "webtraffic" {
    name = "Allow HTTPS"
    dynamic "ingress" {
        iterator = port
        for_each = var.ingressrules
        content {
        from_port = port.value
        to_port = port.value
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
        }
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    } 
}

resource "aws_instance" "ec2" {
    ami = "ami-096800910c1b781ba"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.webtraffic.name]
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

module "module_lambda" {
  source = "./lambda"
}