# -------------------------------------------------------
# Copyright (c) [2021] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Simple deployment for subnet testing
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------


# -------------------------------------------------------
# Local test variables
# -------------------------------------------------------
locals {
	test_subnets = [
		{ 	name 	= "test-1", cidr = "10.2.0.0/28", region = "eu-west-1a",
			egress 	= [ { cidr = "10.2.0.16/28", from = 443, to = 443, protocol = "tcp"} ],
			ingress = [ { cidr = "10.2.0.16/28", from = 443, to = 443, protocol = "tcp"} ]
		},
		{ 	name = "test-2", cidr = "10.2.0.16/28", region = "eu-west-1b",
			egress 	= [ { cidr = "10.2.0.0/28", from = 443, to = 443, protocol = "tcp"} ],
			ingress = [ { cidr = "10.2.0.0/28", from = 443, to = 443, protocol = "tcp"} ]
		},
		{ 	name = "test-3", cidr = "10.2.0.32/28", region = "eu-west-1a",
			egress 	= [ { cidr = "10.2.0.16/28", from = 443, to = 443, protocol = "tcp"} ],
			ingress = [ { cidr = "10.2.0.16/28", from = 443, to = 443, protocol = "tcp"} ]
		},
		{ 	name = "test-4", cidr = "10.2.0.48/28", region = "eu-west-1b",
			egress 	= [ { cidr = "10.2.0.32/28", from = 443, to = 443, protocol = "tcp"} ],
			ingress = [ { cidr = "10.2.0.32/28", from = 443, to = 443, protocol = "tcp"} ]
		},
		{	name = "test-5", cidr = "10.2.0.64/28", region = "eu-west-1a",
			egress 	= [ { cidr = "10.2.0.0/28", from = 443, to = 443, protocol = "tcp"} ],
			ingress = [ { cidr = "10.2.0.0/28", from = 443, to = 443, protocol = "tcp"} ]
		}
	]
}
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
module "subnets" {

	count 		= length(local.test_subnets)

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
		cidr 	= local.test_subnets[count.index].cidr
		region 	= local.test_subnets[count.index].region
		name 	= local.test_subnets[count.index].name
	}
	egress = local.test_subnets[count.index].egress
	ingress = local.test_subnets[count.index].ingress
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

output "subnets" {
	value = module.subnets.*.subnet.id
}