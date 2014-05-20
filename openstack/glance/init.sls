glance:
  service:
    - running
    - enable: True
    - names:
      - glance-api
      - glance-registry
    - require:
      - pkg: glance
  pkg:
    - installed
    - names:
      - glance
      - glance-api
      - glance-common
      - glance-registry
      - python-glanceclient

glance-storage:
  file.directory:
    - name: {{ salt['pillar.get']('openstack:glance:api:filesystem_store_datadir', '/var/lib/glance/images') }}
    - user: glance
    - group: glance
    - mode: 754
    - recurse:
      - user
      - group

{% for conf in ['glance-api','glance-registry'] %}

{{ conf }}.conf:
  file.managed:
    - name: /etc/glance/{{ conf }}.conf
    - source: salt://openstack-{{ pillar['openstack']['version'] }}/{{ conf }}.conf
    - template: jinja
    - require:
      - pkg: glance
    - watch:
      - service: glance

{% endfor %}
