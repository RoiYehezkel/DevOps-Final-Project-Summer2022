terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

# Create a VPC
resource "aws_vpc" "roi-yehezkel-dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "RoiYehezkel-dev-vpc"
  }
}

resource "aws_subnet" "roi-yehezkel-k8s-subnet" {
  vpc_id     = aws_vpc.roi-yehezkel-dev-vpc.id
  cidr_block = "10.0.0.0/27"
  tags = {
    "Name" = "RoiYehezkel-k8s-subnet"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.roi-yehezkel-dev-vpc.id
  tags = {
    Name = "instance-gateway"
  }
}

resource "aws_route" "routeIGW" {
  route_table_id         = aws_vpc.roi-yehezkel-dev-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}
