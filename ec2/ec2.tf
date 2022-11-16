variable "ec2_name" {
    type = string
}


resource "aws_instance" "ec2" {
    ami = "ami-096800910c1b781ba"
    instance_type = "t2.micro"
    tags = {
        terraform = "true"
        Name = var.ec2_name
    }
}