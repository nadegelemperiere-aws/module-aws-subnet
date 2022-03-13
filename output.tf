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

output "subnet" {
    value = {
        id = aws_subnet.subnet.id
        arn = aws_subnet.subnet.arn
        cidr = aws_subnet.subnet.cidr_block 
        account = aws_subnet.subnet.owner_id
    }
}

output "nacl" {
    value = {
        id = aws_network_acl.subnet_acl.id
        arn = aws_network_acl.subnet_acl.arn
        account = aws_network_acl.subnet_acl.owner_id
    }
}