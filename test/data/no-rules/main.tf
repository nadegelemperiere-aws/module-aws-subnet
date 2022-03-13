# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2021] Technogix.io
# All rights reserved
# -------------------------------------------------------
# Simple deployment for subnet testing
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------

# -------------------------------------------------------
# Create a network
# -------------------------------------------------------
resource "aws_vpc" "test" {
	cidr_block  = "10.2.0.0/24"
   	tags 		= { Name = "test.vpc" }
}

# -------------------------------------------------------
# Create the default network route table
# -------------------------------------------------------
resource "aws_default_route_table" "test" {
	default_route_table_id	= aws_vpc.test.default_route_table_id
	tags 		= { Name = "test.vpc.route" }
}

# -------------------------------------------------------
# Create subnets using the current module
# -------------------------------------------------------
module "subnet" {

	source 		= "../../../"
	email 		= "moi.moi@moi.fr"
	project 	= "test"
	environment = "test"
	module 		= "test"
	git_version = "test"
	vpc 		= {
		id 		= aws_vpc.test.id
		route 	= aws_default_route_table.test.id
	}
	subnet 		= {
		cidr 	= "10.2.0.0/26"
		region 	= "eu-west-1a"
		name 	= "test"
	}
	egress = []
	ingress = []
}

# -------------------------------------------------------
# Terraform configuration
# -------------------------------------------------------
provider "aws" {
	region		= var.region
	access_key 	= var.access_key
	secret_key	= var.secret_key
}

terraform {
	required_version = ">=1.0.8"
	backend "local"	{
		path="terraform.tfstate"
	}
}

# -------------------------------------------------------
# Region for this deployment
# -------------------------------------------------------
variable "region" {
	type    = string
}

# -------------------------------------------------------
# AWS credentials
# -------------------------------------------------------
variable "access_key" {
	type    	= string
	sensitive 	= true
}
variable "secret_key" {
	type    	= string
	sensitive 	= true
}

# -------------------------------------------------------
# Test outputs
# -------------------------------------------------------
output "vpc" {
	value = {
		id 		= aws_vpc.test.id
		route 	= aws_default_route_table.test.id
	}
}

output "subnet" {
	value = module.subnet.subnet.id
}