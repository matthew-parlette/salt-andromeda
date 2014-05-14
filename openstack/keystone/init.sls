keystone:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - restart: True
    - require:
      - pkg: keystone
    - watch:
      - file: keystone-conf-connection
      - file: keystone-conf-admin-token
      - file: keystone-conf-log-dir

{% set keystone_conf = "/etc/keystone/keystone.conf" %}

keystone-conf-connection:
  file.replace:
    - name: /etc/keystone/keystone.conf
    - pattern: "^connection = .*$"
    - repl: "connection = mysql://keystone:{{  salt['pillar.get']('openstack:database:keystone','keystone') }}@{{  salt['pillar.get']('openstack:controller','controller') }}/keystone"
    - require:
      - pkg: keystone

keystone-conf-admin-token:
  file.replace:
    - name: /etc/keystone/keystone.conf
    - pattern: '^#?admin_token\s?=.*$'
    - repl: "admin_token = {{  salt['pillar.get']('openstack:token:admin','ADMIN') }}"
    - require:
      - pkg: keystone

keystone-conf-log-dir:
  file.replace:
    - name: /etc/keystone/keystone.conf
    - pattern: '^#?log_dir\s?=.*$'
    - repl: "log_dir = {{  salt['pillar.get']('openstack:keystone:log_dir','/var/log/keystone') }}"
    - require:
      - pkg: keystone
