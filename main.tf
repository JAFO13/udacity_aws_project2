# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
/* Remove if possible
  access_key = "AKIATDJ7NHHSB3DUL224"
  secret_key = "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"
*/
  region = var.Udacity_region
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2

resource "aws_instance" "Udacity_proj2_exer1a" {
    count = "4"
  ami = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  tags = {
      Name = "Udacity T2"
  }
}


# TODO: provision 2 m4.large EC2 instances named Udacity M4

resource "aws_instance" "Udacity_proj2_exer1b" {
    count = "2"
  ami = "ami-090fa75af13c156b4"
  instance_type = "m4.large"
  tags = {
    Name = "Udacity M4"
  }
}

# TODO: Create IAM role for Lambda
data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "Udacity_project2_lambda_role" {
  name = "Udacity_project2_lambda_role"
  assume_role_policy = "${data.aws_iam_policy_document.AWSLambdaTrustPolicy.json}"
}

resource "aws_iam_role_policy_attachment" "Udacity_project2_lambda_role" {
  role = "${aws_iam_role.Udacity_project2_lambda_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "Udacity_project2_task5_function" {
  filename = "lambda.py.zip"
  handler = "lambda.lambda_handler"
  function_name = "Udacity_project2_Task5_Step2_lambda"
    role = "${aws_iam_role.Udacity_project2_lambda_role.arn}"
    runtime = "python3.9"
  environment {
    variables = {greeting = "Hello From LambdaLand + Terraform"
    }
  }
}

# TODO: Create VPC

resource "aws_vpc" "udacity_project2_task5_part2" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  instance_tenancy = "default"

  tags = {
    Name = "udacity-project2"
  }
}

# TODO: Create Public Subnet
resource "aws_subnet" "udacity-subnet-public-1" {
  vpc_id = "${aws_vpc.udacity_project2_task5_part2.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"

  tags = {
    Name = "udacity-subnet-public-1"
  }
}