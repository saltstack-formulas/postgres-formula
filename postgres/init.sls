
include:
{% if grains.os == 'MacOS' %}
  - postgres.macos
{% else %}
  - postgres.server
  - postgres.server.image
  - postgres.client
  - postgres.manage
{% endif %}
