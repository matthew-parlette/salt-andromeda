keystone-tenants:
  keystone.tenant_present:
    - names:
      {% for tenant in salt['pillar.get']('openstack:tenant',['admin','service']) %}
      - {{ tenant }}
      {% endfor %}

keystone-roles:
  keystone.role_present:
    - names:
      {% for role in salt['pillar.get']('openstack:role',['admin','member']) %}
      - {{ role }}
      {% endfor %}

{% for user in salt['pillar.get']('openstack:user',[]) %}
{{ user }}:
  keystone.user_present:
    - password: {{ salt['pillar.get']('openstack:user:' ~ user ~ ':password','') }}
    - email: {{ salt['pillar.get']('openstack:user:' ~ user ~ ':email',user ~ '@andromeda') }}
    - roles:
      {% for tenant in salt['pillar.get']('openstack:user:' ~ user ~ ':roles',[]) %}
      - {{ tenant }}:
        {% for role in salt['pillar.get']('openstack:user:' ~ user ~ ':roles:' ~ tenant,[]) %}
        - {{ role }}
        {% endfor %}
      {% endfor %}
    - require:
      - keystone: keystone-tenants
      - keystone: keystone-roles
{% endfor %}

{% for service in salt['pillar.get']('openstack:service',[]) %}
keystone-service-{{ service }}:
  keystone.service_present:
    - name: {{ service }}
    - service_type: {{ salt['pillar.get']('openstack:service:' ~ service ~ ':type','') }}

keystone-endpoints-{{ service }}:
  keystone.endpoint_present:
    - name: {{ service }}
    - adminurl: {{ salt['pillar.get']('openstack:service:' ~ service ~ ':endpoint:adminurl','') }}
    - internalurl: {{ salt['pillar.get']('openstack:service:' ~ service ~ ':endpoint:internalurl','') }}
    - publicurl: {{ salt['pillar.get']('openstack:service:' ~ service ~ ':endpoint:publicurl','') }}
    - require:
      - keystone: keystone-service-{{ service }}
{% endfor %}
