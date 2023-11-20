# -------------------------------------------------------
# Copyright (c) [2021] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy an aws subnet with all the secure
# components required
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------

# -------------------------------------------------------
# Create the subnets in the input vpc
# -------------------------------------------------------
resource "aws_subnet" "subnet" {

	vpc_id              = var.vpc.id
    availability_zone   = var.subnet.region
    cidr_block          = var.subnet.cidr

	tags = {
		Name           		= "${var.project}.${var.environment}.${var.module}.subnet.${var.subnet.name}"
		Environment     	= var.environment
		Owner   			= var.email
		Project   			= var.project
		Version 			= var.git_version
		Module  			= var.module
		DeployIdentifier	= var.subnet.name
	}
}


# -------------------------------------------------------
# Associate subnet to a route table
# -------------------------------------------------------
resource "aws_route_table_association" "subnet_table" {
	subnet_id      		= aws_subnet.subnet.id
  	route_table_id 		= var.vpc.route
}

# -------------------------------------------------------
# Create the subnets acls
# -------------------------------------------------------
resource "aws_network_acl" "subnet_acl" {

  	vpc_id 		= var.vpc.id
	subnet_ids 	= [aws_subnet.subnet.id]

	tags = {
		Name           		= "${var.project}.${var.environment}.${var.module}.subnet.${var.subnet.name}.nacl"
		Environment     	= var.environment
		Owner   			= var.email
		Project   			= var.project
		Version 			= var.git_version
		Module  			= var.module
	}
}

# -------------------------------------------------------
# Add egress rules in subnet acl
# -------------------------------------------------------
resource "aws_network_acl_rule" "subnet_acl_egress_rules" {

	count = length(var.egress)

	depends_on 			= [aws_network_acl.subnet_acl]
	network_acl_id		= aws_network_acl.subnet_acl.id
  	rule_number    		= (100 + count.index * 50)
  	egress         		= true
  	protocol       		= var.egress[count.index].protocol
  	rule_action    		= "allow"
  	cidr_block     		= var.egress[count.index].cidr
  	from_port      		= var.egress[count.index].from
  	to_port        		= var.egress[count.index].to
}

# -------------------------------------------------------
# Add ingress rules in subnet acl
# -------------------------------------------------------
resource "aws_network_acl_rule" "subnet_acl_ingress_rules" {

	count = length(var.ingress)

	depends_on 			= [aws_network_acl.subnet_acl]
	network_acl_id		= aws_network_acl.subnet_acl.id
  	rule_number    		= (100 + count.index * 50)
  	egress         		= false
  	protocol       		= var.ingress[count.index].protocol
  	rule_action    		= "allow"
  	cidr_block     		= var.ingress[count.index].cidr
  	from_port      		= var.ingress[count.index].from
  	to_port        		= var.ingress[count.index].to
}