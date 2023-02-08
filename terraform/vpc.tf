module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-vpc"
  cidr = "10.16.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c","us-east-1d" ]
  private_subnets = slice(cidrsubnets("10.16.0.0/16", 4,4,4,4,4,4,4,4), 0,4)
  public_subnets  = slice(cidrsubnets("10.16.0.0/16", 4,4,4,4,4,4,4,4), 4,8)

  enable_nat_gateway = true
  enable_vpn_gateway = true

   enable_dns_support = true
  enable_dns_hostnames = true

   public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}