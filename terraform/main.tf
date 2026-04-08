provider "aws" {
  region = "eu-west-1"
}

# ✅ Fetch latest Ubuntu 22.04 LTS
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ✅ EC2 INSTANCE
resource "aws_instance" "app" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t3.micro"  # <-- Updated to t3.micro

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


