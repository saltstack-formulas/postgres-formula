# pkg.install
postgresql:
  pkg.installed:
    {% if grains['os_family'] == 'RedHat' %}
    - name: postgresql
    {% elif grains['os_family'] == 'Debian' %}
    - name: postgresql-9.1
    {% endif %}

