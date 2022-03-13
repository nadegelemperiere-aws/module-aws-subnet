.. image:: docs/imgs/logo.png
   :alt: Logo

=======================
Technogix subnet module
=======================

About The Project
=================

This project contains all the infrastructure as code (IaC) to deploy a secured subnet in an AWS VPC

.. image:: https://badgen.net/github/checks/technogix-terraform/module-aws-subnet
   :target: https://github.com/technogix-terraform/module-aws-subnet/actions/workflows/release.yml
   :alt: Status
.. image:: https://img.shields.io/static/v1?label=license&message=MIT&color=informational
   :target: ./LICENSE
   :alt: License
.. image:: https://badgen.net/github/commits/technogix-terraform/module-aws-subnet/main
   :target: https://github.com/technogix-terraform/robotframework
   :alt: Commits
.. image:: https://badgen.net/github/last-commit/technogix-terraform/module-aws-subnet/main
   :target: https://github.com/technogix-terraform/robotframework
   :alt: Last commit

Built With
----------

.. image:: https://img.shields.io/static/v1?label=terraform&message=1.1.7&color=informational
   :target: https://www.terraform.io/docs/index.html
   :alt: Terraform
.. image:: https://img.shields.io/static/v1?label=terraform%20AWS%20provider&message=4.4.0&color=informational
   :target: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
   :alt: Terraform AWS provider

Getting Started
===============

Prerequisites
-------------


A virtual private cloud structure shall exist in order to integrate the subnet into a wider network.

In order to create the subnet, some information are required :

* The cidr range of the subnet, that shall be included in the vpc cidr and that shall not overlap another existing subnet.

* The vpc route table to associate with the subnet.

* The flows that shall be allowed inside or outside of the subnet in order to declare the access control list

Configuration
-------------

To use this module in a wider terraform deployment, add the module to a terraform deployment using the following module:

.. code:: terraform

    module "subnet" {

        source      = "git::https://github.com/technogix-terraform/module-aws-subnet?ref=<this module version"
        project     = the project to which the permission set belongs to be used in naming and tags
        module      = the project module to which the permission set belongs to be used in naming and tags
        email       = the email of the person responsible for the permission set maintainance
        environment = the type of environment to which the permission set contributes (prod, preprod, staging, sandbox, ...) to be used in naming and tags
        git_version = the version of the deployment that uses the permission sets to be used as tag
        vpc        = {
            id       = the aws id of the virtual private cloud in which the subnet shall be deployed
            route    = the aws id of the vpc route table to associate with the subnet
        }
        subnet      = {
            cidr     = the subnet IPv4 cidr in the form XXX.XXX.XXX.XXX/YY
            region   = the availability zone in which the subnet shall be deployed
            name     = the name of the subnet, that will result in a DeployIdentifier tag to enable identification of the subnet after creation
        }
        egress      = [ the list of access control rules to allow network flows outside the subnet
            { cidr = "0.0.0.0/0", from = 443,   to = 443,   protocol = "tcp" },
            { cidr = "0.0.0.0/0", from = 53,    to = 53,    protocol = "udp" }
        ]
        ingress      = [ the list of access control rules to allow network flows inside the subnet
            { cidr = "0.0.0.0/0", from = 443,   to = 443,   protocol = "tcp"},
            { cidr = "0.0.0.0/0", from = 53,    to = 53,    protocol = "udp"},
            { cidr = "0.0.0.0/0", from = 32768, to = 65535, protocol = "tcp"},
            { cidr = "0.0.0.0/0", from = 32768, to = 65535, protocol = "udp"}
        ]
    }

Usage
-----

The module is deployed alongside the module other terraform components, using the classic command lines :

.. code:: bash

    terraform init ...
    terraform plan ...
    terraform apply ...

Detailed design
===============

.. image:: docs/imgs/module.png
   :alt: Module architecture

The module creates the subnet in the VPC, associate the subnet with the vpc route table.

It then creates an access control list to limit the input and output flow to the required ones.


.. important::
    Access control rules are stateless, meaning rules shall be set up to allow :
   - The egress requests to any location outside of the subnet
   - The ingress response to those requests from the location outside of the subnet
   - The ingress requests from any location outside of the subnet
   - The egress response to those requests to the location outside of the subnet

Testing
=======

Tested With
-----------

.. image:: https://img.shields.io/static/v1?label=technogix_iac_keywords&message=v1.0.0&color=informational
   :target: https://github.com/technogix-terraform/robotframework
   :alt: Technogix iac keywords
.. image:: https://img.shields.io/static/v1?label=python&message=3.10.2&color=informational
   :target: https://www.python.org
   :alt: Python
.. image:: https://img.shields.io/static/v1?label=robotframework&message=4.1.3&color=informational
   :target: http://robotframework.org/
   :alt: Robotframework
.. image:: https://img.shields.io/static/v1?label=boto3&message=1.21.7&color=informational
   :target: https://boto3.amazonaws.com/v1/documentation/api/latest/index.html
   :alt: Boto3

Environment
-----------

Tests can be executed in an environment :

* in which python and terraform has been installed, by executing the script `scripts/robot.sh`_, or

* in which docker is available, by using the `technogix infrastructure image`_ in its latest version, which already contains python and terraform, by executing the script `scripts/test.sh`_

.. _`technogix infrastructure image`: https://github.com/technogix-images/terraform-python-awscli
.. _`scripts/robot.sh`: scripts/robot.sh
.. _`scripts/test.sh`: scripts/test.sh

Strategy
--------

The test strategy consists in terraforming test infrastructures based on the subnet module and check that the resulting AWS infrastructure matches what is expected.
The tests currently contains 2 tests :

1 - A test to check the capability to create multiple subnets based on the module and the terraform *count* keyword

2 - A test to check that when no ACL rules are specified, the subnet ACL still contains a rules that deny all outbound and all inbound traffic.

The tests cases :

* Apply terraform to deploy the test infrastructure

* Use specific keywords to model the expected infrastructure in the boto3 format.

* Use shared EC2 keywords based on boto3 to check that the boto3 input matches the expected infrastructure

NB : It is not possible to completely specify the expected infrastructure, since some of the value returned by boto are not known before apply. The comparaison functions checks that all the specified data keys are present in the output, leaving alone the other undefined keys.

Results
-------

The test results for latest release are here_

.. _here: https://technogix-terraform.github.io/module-aws-subnet/report.html

Issues
======

.. image:: https://img.shields.io/github/issues/technogix-terraform/module-aws-subnet.svg
   :target: https://github.com/technogix-terraform/module-aws-subnet/issues
   :alt: Open issues
.. image:: https://img.shields.io/github/issues-closed/technogix-terraform/module-aws-subnet.svg
   :target: https://github.com/technogix-terraform/module-aws-subnet/issues
   :alt: Closed issues

Roadmap
=======

N.A.

Contributing
============

.. image:: https://contrib.rocks/image?repo=technogix-terraform/module-aws-subnet
   :alt: GitHub Contributors Image

We welcome contributions, do not hesitate to contact us if you want to contribute.

License
=======

This code is under MIT License.

Contact
=======

Nadege LEMPERIERE - nadege.lemperiere@technogix.io

Project Link: `https://github.com/technogix-terraform/module-aws-subnet`_

.. _`https://github.com/technogix-terraform/module-aws-subnet`: https://github.com/technogix-terraform/module-aws-subnet

Acknowledgments
===============

N.A.
