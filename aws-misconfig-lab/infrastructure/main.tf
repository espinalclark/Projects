terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "lab"
}

# ── VPC ──────────────────────────────────────────
resource "aws_vpc" "lab" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "${var.lab_prefix}-vpc" }
}

resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id
  tags   = { Name = "${var.lab_prefix}-igw" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = { Name = "${var.lab_prefix}-public" }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}a"
  tags = { Name = "${var.lab_prefix}-private" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab.id
  }
  tags = { Name = "${var.lab_prefix}-rt-public" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

module "s3_exposed" {
  source     = "./modules/s3_exposed"
  lab_prefix = var.lab_prefix
  account_id = var.account_id
}

module "iam_vulnerable" {
  source     = "./modules/iam_vulnerable"
  lab_prefix = var.lab_prefix
  account_id = var.account_id
}

module "ec2_imdsv1" {
  source                    = "./modules/ec2_imdsv1"
  lab_prefix                = var.lab_prefix
  account_id                = var.account_id
  vpc_id                    = aws_vpc.lab.id
  public_subnet_id          = aws_subnet.public.id
  private_subnet_id         = aws_subnet.private.id
  ec2_instance_profile_name = module.iam_vulnerable.ec2_instance_profile_name
}

module "lambda_injection" {
  source                    = "./modules/lambda_injection"
  lab_prefix                = var.lab_prefix
  account_id                = var.account_id
  lambda_execution_role_arn = module.iam_vulnerable.lambda_execution_role_arn
}

module "cloudtrail_off" {
  source     = "./modules/cloudtrail_off"
  lab_prefix = var.lab_prefix
  account_id = var.account_id
}

module "ecr_secrets" {
  source     = "./modules/ecr_secrets"
  lab_prefix = var.lab_prefix
  account_id = var.account_id
  aws_region = var.aws_region
}

module "persistence" {
  source     = "./modules/persistence"
  lab_prefix = var.lab_prefix
  account_id = var.account_id
}
