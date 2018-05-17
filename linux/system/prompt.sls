{%- from "linux/map.jinja" import system with context %}
{%- if system.enabled %}

/etc/profile.d/prompt.sh:
  file.managed:
    - source: salt://linux/files/prompt.sh
    - template: jinja

{%- if grains.os_family == 'Debian' %}
/etc/bash.bashrc:
  file.replace:
    - pattern: ".*PS1=.*"
    - repl: ": # Prompt is set by /etc/profile.d/prompt.sh"

/etc/skel/.bashrc:
  file.replace:
    - pattern: ".*PS1=.*"
    - repl: ": # Prompt is set by /etc/profile.d/prompt.sh"

{% for user in salt['user.list_users']() %}
{%- set homedir =  salt['user.info'](user).home -%}
{%- if salt['file.file_exists'](homedir + "/.bashrc") %}
{{ homedir }}/.bashrc:
  file.replace:
    - pattern: ".*PS1=.*"
    - repl: ": # Prompt is set by /etc/profile.d/prompt.sh"

{%- endif %}
{% endfor %}
{%- endif %}

{%- endif %}
