Configuration files for my Ubuntu-based network.

hosts
=====
Define the hosts file for each client. This is primarily for the n2n network, so it is easier to just define a static list in the pillar file of all hosts instead of getting the information from each minion.

groups
======
Simply define the groups necessary on each system.

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
init.sls manages the keystone package, service, and config file. This should go in top.sls:

    - salt-andromeda.openstack.keystone

populate.sls adds the users, roles, services, and endpoints.

This is not run as a part of highstate, so to populate the database:

    salt 'server' state.sls salt-andromeda.openstack.keystone.populate
