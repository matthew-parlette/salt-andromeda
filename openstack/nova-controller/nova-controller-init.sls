include:
  - andromeda.openstack.controller.mysql
  - .init

nova-db-sync:
  cmd:
    - run
    - name: nova-manage db sync
    - user: nova
    - require:
      - service: mysql-server
      - mysql_database: nova-db
      - pkg: nova
      - file: nova.conf
