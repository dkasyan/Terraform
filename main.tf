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

variable "iegreessrules" {
  type = list(number)
  default = [80, 443 ]
}

variable "engreesrules" {
  type = list(number)
  default = [80, 443 ]
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



resource "aws_security_group" "webtraffic" {
    name = "Allow HTTPS"
    ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    } 
}

### Lambdy ###

resource "aws_iam_role" "lambda_role" {
  name = "Spacelift_Test_Lambda_Function_Role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name = "aws_iam_policy_for_terraform_aws_lambda_role"
 path = "/"
 description = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

data "archive_file" "zip_the_python_code" {
  type = "zip"
  source_dir = "${path.module}/python/"
  output_path = "${path.module}/python/hello-python.zip"
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename = "${path.module}/python/hello-python.zip"
  function_name = "Spacelift_Test_Lambda_Function"
  role = aws_iam_role.lambda_role.arn
  handler = "script.lambda_handler"
  runtime = "python3.9"
  depends_on = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}