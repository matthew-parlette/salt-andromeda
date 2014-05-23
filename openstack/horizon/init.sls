horizon:
  service:
    - running
    - enable: True
    - names:
      - apache2
      - memcached
    - require:
      - pkg: horizon
      - pkg: openstack-dashboard-ubuntu-theme
    - watch:
      - file: local_settings.py
  pkg:
    - installed
    - names:
      - apache2
      - memcached
      - libapache2-mod-wsgi
      - openstack-dashboard

openstack-dashboard-ubuntu-theme:
  pkg:
    - purged

local_settings.py:
  file.managed:
    - name: /etc/openstack-dashboard/local_settings.py
    - source: salt://openstack-{{ pillar['openstack']['version'] }}/local_settings.py
    - template: jinja
    - require:
      - pkg: horizon
