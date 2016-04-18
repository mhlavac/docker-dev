apache2:
    pkg.installed:
        - require:
            - pkg: php-packages
    service.running:
        - watch:
            - pkg: apache2
            - file: /etc/apache2/*
    require:
        - user: {{ pillar['user']['user'] }}

Disable mpm_event module:
    apache_module.disable:
        - name: mpm_event
        - require:
             - pkg: apache2

Enable Apache rewrite:
    apache_module.enable:
        - name: rewrite
        - require:
            - apache_module: Disable mpm_event module
            - pkg: apache2

Enable mpm_prefork module:
    apache_module.enable:
        - name: mpm_prefork
        - require:
            - apache_module: Disable mpm_event module
            - pkg: apache2

Enable proxy module:
    apache_module.enable:
        - name: proxy_http
        - require:
            - apache_module: Disable mpm_event module
            - pkg: apache2

Enable PHP7.0 module:
    apache_module.enable:
        - name: php7.0
        - require:
            - apache_module: Disable mpm_event module
            - pkg: apache2

/etc/apache2/envvars:
    file.managed:
        - source: salt://apache2/config/envvars
        - require:
            - pkg: apache2

/etc/apache2/sites-enabled:
    file.recurse:
        - source: salt://apache2/config/sites
        - clean: true
        - require:
            - pkg: apache2
            - apache_module: Enable Apache rewrite
            - apache_module: Enable Apache ssl
            - apache_module: Enable mpm_prefork module
            - apache_module: Enable PHP7.0 module
            - apache_module: Enable proxy module

apache2_server_name:
    file.append:
        - name: /etc/apache2/apache2.conf
        - text: 'ServerName app.dev'
        - require:
            - pkg: apache2
