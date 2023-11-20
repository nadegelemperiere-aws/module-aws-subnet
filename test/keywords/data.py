# -------------------------------------------------------
# Copyright (c) [2021] Nadege Lemperiere
# All rights reserved
# -------------------------------------------------------
# Keywords to create data for module test
# -------------------------------------------------------
# Nadège LEMPERIERE, @13 november 2021
# Latest revision: 20 november 2023
# -------------------------------------------------------

# System includes
from json import load, dumps

# Robotframework includes
from robot.libraries.BuiltIn import BuiltIn, _Misc
from robot.api import logger as logger
from robot.api.deco import keyword
ROBOT = False

# ip address manipulation
from ipaddress import IPv4Network

@keyword('Load Multiple Test Data')
def load_multiple_test_data(vpc, route, ids) :

    result = {}
    result['subnets'] = []
    result['nacl'] = []

    if len(ids) != 5 : raise Exception(str(len(ids)) + ' subnets created instead of 5')

    cidrs = list(IPv4Network('10.2.0.0/24').subnets(new_prefix=28))

    for i in range(1,5) :
        subnet = {}
        subnet['Tags'] = []
        subnet['Tags'].append({'Key'        : 'Version'             , 'Value' : 'test'})
        subnet['Tags'].append({'Key'        : 'Project'             , 'Value' : 'test'})
        subnet['Tags'].append({'Key'        : 'Module'              , 'Value' : 'test'})
        subnet['Tags'].append({'Key'        : 'Environment'         , 'Value' : 'test'})
        subnet['Tags'].append({'Key'        : 'Owner'               , 'Value' : 'moi.moi@moi.fr'})
        subnet['Tags'].append({'Key'        : 'Name'                , 'Value' : 'test.test.test.subnet.test-' + str(i)})
        subnet['Tags'].append({'Key'        : 'DeployIdentifier'    , 'Value' : 'test-' + str(i)})
        subnet['VpcId'] = vpc
        subnet['SubnetId'] = ids[i - 1]
        subnet['CidrBlock'] = str(cidrs[i - 1])
        subnet['State'] = 'available'
        if i % 2 == 0 : subnet['AvailabilityZone'] = "eu-west-1b"
        else : subnet['AvailabilityZone'] = "eu-west-1a"

        result['subnets'].append({'name' : 'test-' + str(i), 'data' : subnet})

        nacl = {}
        nacl['Associations'] = [{'SubnetId' : ids[i - 1]}]

        nacl['Tags'] = []
        nacl['Tags'].append({'Key'          : 'Version'     , 'Value' : 'test'})
        nacl['Tags'].append({'Key'          : 'Project'     , 'Value' : 'test'})
        nacl['Tags'].append({'Key'          : 'Module'      , 'Value' : 'test'})
        nacl['Tags'].append({'Key'          : 'Environment' , 'Value' : 'test'})
        nacl['Tags'].append({'Key'          : 'Owner'       , 'Value' : 'moi.moi@moi.fr'})
        nacl['Tags'].append({'Key'          : 'Name'        , 'Value' : 'test.test.test.subnet.test-' + str(i) + '.nacl'})
        nacl['VpcId'] = vpc
        nacl['Entries'] = []

        if i == 1 :
            nacl['Entries'].append({ 'CidrBlock' : '10.2.0.16/28', 'Egress' : True,  'PortRange' : { 'From' : 443, 'To' : 443},  'Protocol' : '6', 'RuleAction' : 'allow'})
            nacl['Entries'].append({ 'CidrBlock' : '0.0.0.0/0', 'Egress' : True, 'Protocol' : '-1', 'RuleAction' : 'deny'})
            nacl['Entries'].append({ 'CidrBlock' : '10.2.0.16/28', 'Egress' : False, 'PortRange' : { 'From' : 443, 'To' : 443},  'Protocol' : '6', 'RuleAction' : 'allow'})
            nacl['Entries'].append({ 'CidrBlock' : '0.0.0.0/0', 'Egress' : False, 'Protocol' : '-1', 'RuleAction' : 'deny'})
        elif i == 2 :
            nacl['Entries'].append({ 'CidrBlock' : '10.2.0.0/28', 'Egress' : True,  'PortRange' : { 'From' : 443, 'To' : 443},  'Protocol' : '6', 'RuleAction' : 'allow'})
            nacl['Entries'].append({ 'CidrBlock' : '0.0.0.0/0', 'Egress' : True, 'Protocol' : '-1', 'RuleAction' : 'deny'})
            nacl['Entries'].append({ 'CidrBlock' : '10.2.0.0/28', 'Egress' : False, 'PortRange' : { 'From' : 443, 'To' : 443},  'Protocol' : '6', 'RuleAction' : 'allow'})
            nacl['Entries'].append({ 'CidrBlock' : '0.0.0.0/0', 'Egress' : False, 'Protocol' : '-1', 'RuleAction' : 'deny'})
        elif i == 3 :
            nacl['Entries'].append({ 'CidrBlock' : '10.2.0.16/28', 'Egress' : True,  'PortRange' : { 'From' : 443, 'To' : 443},  'Protocol' : '6', 'RuleAction' : 'allow'})
            nacl['Entries'].append({ 'CidrBlock' : '0.0.0.0/0', 'Egress' : True, 'Protocol' : '-1', 'RuleAction' : 'deny'})
            nacl['Entries'].append({ 'CidrBlock' : '10.2.0.16/28', 'Egress' : False, 'PortRange' : { 'From' : 443, 'To' : 443},  'Protocol' : '6', 'RuleAction' : 'allow'})
            nacl['Entries'].append({ 'CidrBlock' : '0.0.0.0/0', 'Egress' : False, 'Protocol' : '-1', 'RuleAction' : 'deny'})
        elif i == 4 :
            nacl['Entries'].append({ 'CidrBlock' : '10.2.0.32/28', 'Egress' : True,  'PortRange' : { 'From' : 443, 'To' : 443},  'Protocol' : '6', 'RuleAction' : 'allow'})
            nacl['Entries'].append({ 'CidrBlock' : '0.0.0.0/0', 'Egress' : True, 'Protocol' : '-1', 'RuleAction' : 'deny'})
            nacl['Entries'].append({ 'CidrBlock' : '10.2.0.32/28', 'Egress' : False, 'PortRange' : { 'From' : 443, 'To' : 443},  'Protocol' : '6', 'RuleAction' : 'allow'})
            nacl['Entries'].append({ 'CidrBlock' : '0.0.0.0/0', 'Egress' : False, 'Protocol' : '-1', 'RuleAction' : 'deny'})
        elif i == 5 :
            nacl['Entries'].append({ 'CidrBlock' : '10.2.0.0/28', 'Egress' : True,  'PortRange' : { 'From' : 443, 'To' : 443},  'Protocol' : '6', 'RuleAction' : 'allow'})
            nacl['Entries'].append({ 'CidrBlock' : '0.0.0.0/0', 'Egress' : True, 'Protocol' : '-1', 'RuleAction' : 'deny'})
            nacl['Entries'].append({ 'CidrBlock' : '10.2.0.0/28', 'Egress' : False, 'PortRange' : { 'From' : 443, 'To' : 443},  'Protocol' : '6', 'RuleAction' : 'allow'})
            nacl['Entries'].append({ 'CidrBlock' : '0.0.0.0/0', 'Egress' : False, 'Protocol' : '-1', 'RuleAction' : 'deny'})

        result['nacl'].append({'name' : 'test-' + str(i), 'data' : nacl})

    logger.debug(dumps(result))

    return result

@keyword('Load No Rules Test Data')
def load_no_rules_test_data(vpc, route, id) :

    result = {}
    result['subnet'] = [{'name' : 'test', 'data' : {}}]
    result['nacl'] = [{'name' : 'test', 'data' : {}}]

    result['subnet'][0]['data']['Tags'] = []
    result['subnet'][0]['data']['Tags'].append({'Key'        : 'Version'             , 'Value' : 'test'})
    result['subnet'][0]['data']['Tags'].append({'Key'        : 'Project'             , 'Value' : 'test'})
    result['subnet'][0]['data']['Tags'].append({'Key'        : 'Module'              , 'Value' : 'test'})
    result['subnet'][0]['data']['Tags'].append({'Key'        : 'Environment'         , 'Value' : 'test'})
    result['subnet'][0]['data']['Tags'].append({'Key'        : 'Owner'               , 'Value' : 'moi.moi@moi.fr'})
    result['subnet'][0]['data']['Tags'].append({'Key'        : 'Name'                , 'Value' : 'test.test.test.subnet.test'})
    result['subnet'][0]['data']['Tags'].append({'Key'        : 'DeployIdentifier'    , 'Value' : 'test'})
    result['subnet'][0]['data']['VpcId'] = vpc
    result['subnet'][0]['data']['SubnetId'] = id
    result['subnet'][0]['data']['CidrBlock'] = "10.2.0.0/26"
    result['subnet'][0]['data']['State'] = 'available'
    result['subnet'][0]['data']['AvailabilityZone'] = "eu-west-1a"

    result['nacl'][0]['data']['Associations'] = [{'SubnetId' : id}]
    result['nacl'][0]['data']['Tags'] = []
    result['nacl'][0]['data']['Tags'].append({'Key'          : 'Version'     , 'Value' : 'test'})
    result['nacl'][0]['data']['Tags'].append({'Key'          : 'Project'     , 'Value' : 'test'})
    result['nacl'][0]['data']['Tags'].append({'Key'          : 'Module'      , 'Value' : 'test'})
    result['nacl'][0]['data']['Tags'].append({'Key'          : 'Environment' , 'Value' : 'test'})
    result['nacl'][0]['data']['Tags'].append({'Key'          : 'Owner'       , 'Value' : 'moi.moi@moi.fr'})
    result['nacl'][0]['data']['Tags'].append({'Key'          : 'Name'        , 'Value' : 'test.test.test.subnet.test.nacl'})
    result['nacl'][0]['data']['VpcId'] = vpc
    result['nacl'][0]['data']['Entries'] = []
    result['nacl'][0]['data']['Entries'].append({ 'CidrBlock' : '0.0.0.0/0', 'Egress' : True, 'Protocol' : '-1', 'RuleAction' : 'deny'})
    result['nacl'][0]['data']['Entries'].append({ 'CidrBlock' : '0.0.0.0/0', 'Egress' : False, 'Protocol' : '-1', 'RuleAction' : 'deny'})

    logger.debug(dumps(result))

    return result
