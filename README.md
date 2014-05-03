hosts
=====
Define the hosts file for each client. This is primarily for the n2n network, so it is easier to just define a static list in the pillar file of all hosts instead of getting the information from each minion.

openstack
=========

keystone
--------
init.sls manages the keystone package, service, and config file. This should go in top.sls:

    - salt-andromeda.openstack.keystone

populate.sls adds the users, roles, services, and endpoints.

This is not run as a part of highstate, so to populate the database:

    salt 'server' state.sls salt-andromeda.openstack.keystone.populate
