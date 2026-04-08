provider "aws" {
  region = "eu-west-1"
}

# ✅ DATA SOURCE: Fetch latest Amazon Linux 2 AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon official account
}

# ✅ EC2 INSTANCE
resource "aws_instance" "app" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"

  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.sg_id]

  iam_instance_profile = "ikenna-ec2-ssm-prod-role"

  user_data = file("userdata.sh")

  tags = {
    Name = "fullstack-practice"
  }
}

terraform {
  backend "s3" {
    bucket         = "fullstack-practice-tf-state-ikenna"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}


