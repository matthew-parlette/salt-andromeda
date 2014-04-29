rabbitmq-server:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - restart: True
    - require:
      - pkg: rabbitmq-server

setup-rabbit:
  cmd:
    - run
    - name: rabbitmqctl change_password guest {{ salt['pillar.get']('openstack:password:rabbitmq', 'guest') }}
    - require:
      - pkg: rabbitmq-server
      - service: rabbitmq-server
