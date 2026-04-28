resource "aws_instance" "ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  user_data = file(var.user_data)

  tags = {
    Name = var.instance_name
  }
}