nova:
  service:
    - running
    - enable: True
    - names:
      - nova-compute
    - require:
      - pkg: nova
      - cmd: nova-kernel-security
      - file: nova-instances-storage
      - file: nova-volumes-storage
  pkg:
    - installed
    - names:
      - nova-compute-kvm
      - python-guestfs

nova-kernel-security:
  file.managed:
    - name: /etc/kernel/postinst.d/statoverride
    - source: salt://openstack-{{ pillar['openstack']['version'] }}/statoverride
    - user: root
    - group: root
    - mode: 655
  cmd:
    - run
    - name: 'dpkg-statoverride  --update --add root root 0644 /boot/vmlinuz-$(uname -r)'

{% for storage_type in ['instances','volumes'] %}

nova-{{ storage_type }}-storage:
  file.directory:
    - name: {{ salt['pillar.get']('openstack:nova:' ~ storage_type ~ '_path', '/var/lib/nova/' ~ storage_type) }}
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
