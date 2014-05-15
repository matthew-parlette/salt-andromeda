Configuration files for my Ubuntu-based network.

hosts
=====
Define the hosts file for each client. This is primarily for the n2n network, so it is easier to just define a static list in the pillar file of all hosts instead of getting the information from each minion.

groups
======
Simply define the groups necessary on each system.

packages
========
Install packages from:

* Standard Ubuntu packages

* PPA-based packages

* Packages from apt sources

See the pillar.example for specifying the packages. Note that the standard ubuntu packages need to have a trailing colon for everything to work properly.

openstack
=========
mysql
-----
Mysql is setup outside of top.sls:

    salt 'server' state.sls salt-andromeda.openstack.controller.mysql

Run this again for any changes to the pillar file.

rabbitmq
--------
Rabbitmq is setup outside of top.sls:

    salt 'server' state.sls salt-andromeda.openstack.controller.rabbitmq

Run this again for any changes to the pillar file.

keystone
--------
To setup keystone:
1. Run the salt state for keystone-init

    salt 'server' state.sls salt-andromeda.openstack.keystone.keystone-init

1. Add the keystone sls to the top.sls file

init.sls manages the keystone package, service, and config file. This should go in top.sls:

    - salt-andromeda.openstack.keystone

keystone-init.sls adds the users, roles, services, and endpoints.

This is not run as a part of highstate, so to initialize the keystone database:

    salt 'server' state.sls salt-andromeda.openstack.keystone.keystone-init
