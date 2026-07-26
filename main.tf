provider "aws" { 
    region = var.aws_region 
    }

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "ec2" {
  source        = "./modules/ec2"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]
  instance_type = "t3.micro"
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = "production-eks-cluster"
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "rds" {
  source                    = "./modules/rds"
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.private_subnet_ids
  allowed_security_group_id = module.ec2.security_group_id
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "unique-app-data-bucket-corp-xyz"
}
