module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr         = "10.0.0.0/16"
  vpc_name         = "dev-vpc"
  private_subnet_1 = "10.0.1.0/24"
  private_subnet_2 = "10.0.2.0/24"
  az1              = "us-east-1a"
  az2              = "us-east-1b"
}

module "ec2" {
  source = "../../modules/ec2"

  ami            = var.ami
  instance_type  = "t3.micro"
  subnet_id      = module.vpc.subnet_1_id
  instance_name  = "dev-ec2"
  user_data      = "${path.module}/../../scripts/user_data.sh"
  security_group_id = module.vpc.security_group_id
  depends_on = [module.vpc]
}