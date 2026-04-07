provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "app" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  subnet_id = var.subnet_id

  vpc_security_group_ids = [var.sg_id]

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  user_data = file("userdata.sh")

  tags = {
    Name = "fullstack-practice"
  }
}
