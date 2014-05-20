include:
  - andromeda.openstack.controller.mysql
  - .init

glance-db-sync:
  cmd:
    - run
    - name: glance-manage db_sync
    - user: glance
    - require:
      - service: mysql-server
      - mysql_database: glance-db
      - pkg: glance
      - file: glance-api.conf
      - file: glance-registry.conf
