provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "app" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  subnet_id = var.subnet_id

  vpc_security_group_ids = [var.sg_id]

  # Use your existing IAM role (instance profile must have SSM permissions)
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



