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

resource "aws_iam_role" "ssm_role" {
  name = "ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-instance-profile-1"
  role = aws_iam_role.ssm_role.name
}




