{#
  Salt State to Install and Configure Aria Automation Config Master Plugin
#}

{% set eapi_endpoint = salt['pillar.get']('sse_eapi_endpoint', 'localhost') %}
{% set eapi_ssl_enabled = salt['pillar.get']('sse_eapi_ssl_enabled', 'True') %}
{% if eapi_ssl_enabled %}
{% set eapi_url = "https://%s"|format(eapi_endpoint) %}
{% else %}
{% set eapi_url = "http://%s"|format(eapi_endpoint) %}
{% endif %}
{% set eapi_ssl_validation = salt['pillar.get']('sse_eapi_ssl_validation', 'False') %}
{% set eapi_username = salt['pillar.get']('sse_eapi_username', 'root') %}
{% set eapi_password = salt['pillar.get']('sse_eapi_password', 'salt') %}
{% set eapi_cluster_id = salt['pillar.get']('sse_cluster_id', 'salt') %}
{% set eapi_failover_master = salt['pillar.get']('sse_eapi_failover_master', 'False') %}

{% set eapi_egg_path = salt['grains.get']('saltpath')|replace('site-packages/salt', 'site-packages/') %}

{% set eapi_egg = "SSEAPE-8.13.1.4-py3-none-any.whl" %}

{% if salt['grains.get']('saltpath').startswith('/opt') %}
{% set pip_install_opts = '' %}
{% else %}
{% set pip_install_opts = '--prefix /usr' %}
{% endif %}

remove_retired_sseapi_modules:
  cmd.run:
    - name: 'ls -d SSEAPE* | grep -v {{ eapi_egg }} | xargs rm -Rf'
    - cwd: {{ eapi_egg_path }}
    - onlyif:
      - ls -d {{ eapi_egg_path }}SSEAPE* | grep -v {{ eapi_egg }}

# Deploy the Egg
{% if not salt['file.directory_exists'](eapi_egg_path + eapi_egg) %}

deliver_eapi_egg:
  file.managed:
    - name: /tmp/{{ eapi_egg }}
    - source: salt://{{ slspath }}/files/{{ eapi_egg }}

easy_install_eapi_egg:
  cmd.run:
    - name: {{ salt['grains.get']('pythonexecutable') }} -m pip install /tmp/{{ eapi_egg }} {{ pip_install_opts }}

remove_eapi_egg_tmp_file:
  file.absent:
    - name: /tmp/{{ eapi_egg }}

{% endif %}

configure_raas_plugin:
  file.managed:
    - name: /etc/salt/master.d/raas.conf
    - source: salt://{{ slspath }}/files/raas.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - context:
        eapi_url: {{ eapi_url }}
        eapi_cluster_id: {{ eapi_cluster_id }}
        eapi_failover_master: {{ eapi_failover_master }}
        eapi_ssl_enabled: {{ eapi_ssl_enabled }}
        eapi_ssl_validation: {{ eapi_ssl_validation }}

configure_eapi_master_paths:
  file.managed:
    - name: /etc/salt/master.d/eAPIMasterPaths.conf
    - source: salt://{{ slspath }}/files/eAPIMasterPaths.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
        eapi_egg_path: {{ eapi_egg_path }}
        eapi_egg: {{ eapi_egg }}

restart_salt_master:
  cmd.run:
    - name: salt-call service.restart salt-master
    - onchanges:
      - file: configure_raas_plugin

restart_salt_minion:
  cmd.run:
    - name: salt-call service.restart salt-minion
    - onchanges:
      - file: configure_raas_plugin
