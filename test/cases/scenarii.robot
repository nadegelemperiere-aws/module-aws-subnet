# -------------------------------------------------------
# TECHNOGIX
# -------------------------------------------------------
# Copyright (c) [2021] Technogix.io
# All rights reserved
# -------------------------------------------------------
# Robotframework test suite for module
# -------------------------------------------------------
# Nadège LEMPERIERE, @12 november 2021
# Latest revision: 20 november 2023
# -------------------------------------------------------


*** Settings ***
Documentation   A test case to check multiple subnets creation using module
Library         aws_iac_keywords.terraform
Library         aws_iac_keywords.keepass
Library         aws_iac_keywords.ec2
Library         ../keywords/data.py
Library         OperatingSystem

*** Variables ***
${KEEPASS_DATABASE}                 ${vault_database}
${KEEPASS_KEY_ENV}                  ${vault_key_env}
${KEEPASS_PRINCIPAL_KEY_ENTRY}      /aws/aws-principal-access-key
${REGION}                           eu-west-1

*** Test Cases ***
Prepare Environment
    [Documentation]         Retrieve principal credential from database and initialize python tests keywords
    ${keepass_key}          Get Environment Variable          ${KEEPASS_KEY_ENV}
    ${principal_access}     Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_PRINCIPAL_KEY_ENTRY}            username
    ${principal_secret}     Load Keepass Database Secret      ${KEEPASS_DATABASE}     ${keepass_key}  ${KEEPASS_PRINCIPAL_KEY_ENTRY}            password
    Initialize Terraform    ${REGION}   ${principal_access}   ${principal_secret}
    Initialize Ec2          None        ${principal_access}   ${principal_secret}    ${REGION}

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

