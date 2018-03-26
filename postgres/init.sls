
include:
{% if grains.os == 'MacOS' %}
  - postgres.macos
{% else %}
  - postgres.server
  - postgres.client
  - postgres.manage
{% endif %}
