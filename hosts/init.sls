{% for ip in salt['pillar.get']('hosts',None) %}
{{ ip }}:
  host.present:
    - ip: {{ ip }}
    - names:
      {% for hostname in salt['pillar.get']('hosts:' ~ ip,[]) %}
      - {{ hostname }}
      {% endfor %}
{% endfor %}
