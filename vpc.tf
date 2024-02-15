module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = var.VPC_NAME
  cidr   = var.VPC_CIDR

  azs             = [var.ZONE1, var.ZONE2, var.ZONE3]
  private_subnets = [var.PRV_SUB1, var.PRV_SUB2, var.PRV_SUB3]
  public_subnets  = [var.PUB_SUB1, var.PUB_SUB2, var.PUB_SUB3]
  /*Notice that if we have  multiple subnets  then  it will  provision  by default   multiple subnets =>  cosstly  */
  /*  enable_nat_gateway = true
  single_nat_gateway=true
  enable_dns_hostnames = true
  enable_dns_support   = true*/
  /* enable_s3_endpoint= true*/


  tags = {
    Terraform   = "true"
    Environment = "Dev"
  }
  vpc_tags = {
    Name = var.VPC_NAME
  }
}