# -------------------------------------------------------
# Copyright (c) [2021] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Module to deploy an aws subnet with all the secure
# components required
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 20 november 2023
# -------------------------------------------------------

# -------------------------------------------------------
# Contact e-mail for this deployment
# -------------------------------------------------------
variable "email" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# Environment for this deployment (prod, preprod, ...)
# -------------------------------------------------------
variable "environment" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# Topic context for this deployment
# -------------------------------------------------------
variable "project" {
	type     = string
	nullable = false
}
variable "module" {
	type 	 = string
	nullable = false
}

# -------------------------------------------------------
# Solution version
# -------------------------------------------------------
variable "git_version" {
	type     = string
	nullable = false
	default  = "unmanaged"
}

# -------------------------------------------------------
# VPC in which the subnet shall be created
# -------------------------------------------------------
variable "vpc" {
	type = object({
		id 		= string,
		route 	= string
    })
	nullable = false
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
	nullable = false
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
	nullable = false
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
	nullable = false
}
