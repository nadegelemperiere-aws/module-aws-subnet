# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2021] Technogix.io
# All rights reserved
# -------------------------------------------------------
# Robotframework test suite for module
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 12 november 2021
# -------------------------------------------------------


*** Settings ***
Documentation   A test case to check multiple subnets creation using module
Library         technogix_iac_keywords.terraform
Library         technogix_iac_keywords.keepass
Library         technogix_iac_keywords.ec2
Library         ../keywords/data.py

*** Variables ***
${KEEPASS_DATABASE}                 ${vault_database}
${KEEPASS_KEY}                      ${vault_key}
${KEEPASS_GOD_KEY_ENTRY}            /engineering-environment/aws/aws-god-access-key
${REGION}                           eu-west-1

*** Test Cases ***
Prepare Environment
    [Documentation]         Retrieve god credential from database and initialize python tests keywords
    ${god_access}           Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${KEEPASS_KEY}  ${KEEPASS_GOD_KEY_ENTRY}            username
    ${god_secret}           Load Keepass Database Secret            ${KEEPASS_DATABASE}     ${KEEPASS_KEY}  ${KEEPASS_GOD_KEY_ENTRY}            password
    Initialize Terraform    ${REGION}   ${god_access}   ${god_secret}
    Initialize Ec2          None        ${god_access}   ${god_secret}    ${REGION}

Create Multiple Subnets
    [Documentation]         Create Subnets And Check That The AWS Infrastructure Match Specifications
    Launch Terraform Deployment                 ${CURDIR}/../data/multiple
    ${states}   Load Terraform States           ${CURDIR}/../data/multiple
    ${specs}    Load Multiple Test Data         ${states['test']['outputs']['vpc']['value']['id']}   ${states['test']['outputs']['vpc']['value']['route']}    ${states['test']['outputs']['subnets']['value']}
    Subnets Shall Exist And Match               ${specs['subnets']}
    NACL Shall Exist And Match                  ${specs['nacl']}
    [Teardown]  Destroy Terraform Deployment    ${CURDIR}/../data/multiple

Create subnet Without ACL Rules
    [Documentation]         Create Subnet With No ACL Rules And Check That A Deny Rule Exists In The Infrastructure
    Launch Terraform Deployment                 ${CURDIR}/../data/no-rules
    ${states}   Load Terraform States           ${CURDIR}/../data/no-rules
    ${specs}    Load No Rules Test Data         ${states['test']['outputs']['vpc']['value']['id']}   ${states['test']['outputs']['vpc']['value']['route']}    ${states['test']['outputs']['subnet']['value']}
    Subnets Shall Exist And Match               ${specs['subnet']}
    NACL Shall Exist And Match                  ${specs['nacl']}
    [Teardown]  Destroy Terraform Deployment    ${CURDIR}/../data/no-rules

