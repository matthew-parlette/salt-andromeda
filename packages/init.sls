{% for pkg in salt['pillar.get']('packages', []) %}
{% set ppa = salt['pillar.get']('packages:' ~ pkg ~ ':ppa', None) %}
{{ pkg }}:
  {% if ppa %}
  pkgrepo.managed:
    - ppa: {{ ppa }}
  pkg.latest:
    - refresh: True
    - require:
      - pkgrepo: {{ pkg }}
  {% endif %}
{% endfor %}
