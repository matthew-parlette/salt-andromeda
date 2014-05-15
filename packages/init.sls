{% for pkg in salt['pillar.get']('packages', []) %}
{% set params = salt['pillar.get']('packages:' ~ pkg, None) %}
{{ pkg }}:
  {% if params %}
  pkgrepo.managed:
    {% for key,value in params.iteritems() %}
    - {{ key }}: {{ value }}
    {% endfor %}
  pkg.latest:
    - refresh: True
    - require:
      - pkgrepo: {{ pkg }}
  {% else %}
  pkg.latest:
    - refresh: True
  {% endif %}
{% endfor %}
