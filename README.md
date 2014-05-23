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

glance
------
To setup glance:

1. Run the salt state for glance-init

    salt 'server' state.sls salt-andromeda.openstack.glance.glance-init

1. Add the glance sls to the top.sls file

init.sls manages the glance package, service, and config file. This should go in top.sls:

    - salt-andromeda.openstack.glance

keystone-init.sls adds the users, roles, services, and endpoints.

For now, the glance module doesn't seem to work (with ubuntu 14.04, openstack icehouse), so glance images must be added on the server (rather than through salt)

nova-controller
---------------
** Incomplete! **
This state should be applied to the controller

To setup nova-controller:

1. Run the salt state for nova-controller-init

    salt 'server' state.sls salt-andromeda.openstack.nova.nova-controller-init

1. Add the nova-controller sls to the top.sls file

init.sls manages the nova packages, services, and config file. This should go in top.sls:

    - salt-andromeda.openstack.nova-controller

keystone-init.sls adds the users, roles, services, and endpoints.

networks were created outside of salt:

    nova network-create test-net --bridge br100 --multi-host T --fixed-range-v4 10.0.0.0/24
