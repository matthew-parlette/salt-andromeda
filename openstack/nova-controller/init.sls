nova:
  service:
    - running
    - enable: True
    - names:
      - nova-api
      - nova-cert
      - nova-conductor
      - nova-consoleauth
      - nova-novncproxy
      - nova-scheduler
    - require:
      - pkg: nova
    - watch:
      - file: nova.conf
      - file: nova-instances-storage
      - file: nova-volumes-storage
  pkg:
    - installed
    - names:
      - nova-api
      - nova-cert
      - nova-conductor
      - nova-consoleauth
      - nova-novncproxy
      - nova-scheduler
      - python-novaclient

{% for storage_type in ['instances','volumes'] %}

nova-{{ storage_type }}-storage:
  file.directory:
    - name: {{ salt['pillar.get']('openstack:nova:' ~ storage_type ~ 'path', '/var/lib/nova/' ~ storage_type) }}
    - user: nova
    - group: nova
    - mode: 754
    - recurse:
      - user
      - group

{% endfor %}

nova.conf:
  file.managed:
    - name: /etc/nova/nova.conf
    - source: salt://openstack-{{ pillar['openstack']['version'] }}/nova.conf
    - template: jinja
    - require:
      - pkg: nova
