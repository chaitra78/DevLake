module "security" {
  source  = "./modules/security"
  vpc_id  = module.vpc.vpc_id
}

module "ec2" {
  source             = "./modules/ec2"
  ami_id             = var.ami_id
  instance_type      = "t2.micro"
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_id  = module.security.security_group_id
}

module "alb" {
  source             = "./modules/alb"
  security_group_id  = module.security.security_group_id
  subnet_ids         = module.vpc.public_subnet_ids
  vpc_id             = module.vpc.vpc_id
  instance_id        = module.ec2.instance_id
}

module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones    = ["us-east-1a", "us-east-1b"]
}
