module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr         = "10.0.0.0/16"
  vpc_name         = "dev-vpc"
  private_subnet_1 = "10.0.1.0/24"
  private_subnet_2 = "10.0.2.0/24"
  az1              = "us-east-1a"
  az2              = "us-east-1b"
}

# -------------------------
# SECURITY GROUPS
# -------------------------
module "security" {
  source = "../../modules/security"

  vpc_id = module.vpc.vpc_id
}

# -------------------------
# EC2 INSTANCE
# -------------------------
module "ec2" {
  source = "../../modules/ec2"

  ami               = var.ami
  instance_type     = "t3.micro"
  subnet_id         = module.vpc.subnet_1_id
  instance_name     = "dev-ec2"
  user_data         = "${path.module}/../../scripts/user_data.sh"
  security_group_id = module.security.ec2_sg

  depends_on = [module.vpc]
}

# -------------------------
# ECR
# -------------------------
module "ecr" {
  source = "../../modules/ecr"

  repository_name = "dev-app-repo"
}

# -------------------------
# IAM ROLE
# -------------------------
module "iam" {
  source = "../../modules/iam"
}

# -------------------------
# APPLICATION LOAD BALANCER
# -------------------------
module "alb" {
  source = "../../modules/alb"

  vpc_id            = module.vpc.vpc_id
  security_group_id = module.security.alb_sg
  public_subnets    = module.vpc.public_subnets
}

# -------------------------
# ECS
# -------------------------
module "ecs" {
  source = "../../modules/ecs"

  execution_role_arn = module.iam.execution_role_arn
  image_url          = "${module.ecr.repository_url}:latest"

  private_subnets = module.vpc.private_subnets

  security_group_id = module.security.ecs_sg
  target_group_arn  = module.alb.target_group_arn

  depends_on = [
    module.alb,
    module.ecr,
    module.iam
  ]
}

# -------------------------
# OUTPUTS
# -------------------------
output "alb_url" {
  value = module.alb.alb_dns_name
}

output "ecr_repo_url" {
  value = module.ecr.repository_url
}