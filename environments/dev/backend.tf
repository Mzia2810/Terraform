terraform {
  backend "s3" {
    bucket = "s3-terraform-state-devops-zia"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}