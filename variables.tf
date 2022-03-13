# -------------------------------------------------------
# TECHNOGIX 
# -------------------------------------------------------
# Copyright (c) [2021] Technogix.io
# All rights reserved 
# -------------------------------------------------------
# Module to deploy an aws subnet with all the secure 
# components required
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------

# -------------------------------------------------------
# Contact e-mail for this deployment
# -------------------------------------------------------
variable "email" {
	type 	= string
}

# -------------------------------------------------------
# Environment for this deployment (prod, preprod, ...)
# -------------------------------------------------------
variable "environment" {
	type 	= string
}

# -------------------------------------------------------
# Topic context for this deployment
# -------------------------------------------------------
variable "project" {
	type    = string
}
variable "module" {
	type 	= string
}

# -------------------------------------------------------
# Solution version
# -------------------------------------------------------
variable "git_version" {
	type    = string
	default = "unmanaged"
}

# -------------------------------------------------------
# VPC in which the subnet shall be created
# -------------------------------------------------------
variable "vpc" {
	type = object({
		id 		= string,
		route 	= string
    })
}

#  -------------------------------------------------------
# Subnet description
# --------------------------------------------------------
variable "subnet" {
	type = object({
        name 	= string,
		cidr 	= string,
		region 	= string
    })
}

#  -------------------------------------------------------
# Egress acl rules to associate to subnet 
# --------------------------------------------------------
variable "egress" {
	type = list(object({
		cidr = string,
		from = number,
		to = number,
		protocol = string
	}))
}

#  -------------------------------------------------------
# Ingress acl rules to associate to subnet 
# --------------------------------------------------------
variable "ingress" {
	type = list(object({
		cidr = string,
		from = number,
		to = number,
		protocol = string
	}))
}
