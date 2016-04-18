php_ppa:
    pkgrepo.managed:
        - humanname: PHP
        - name: deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main
        - dist: trusty
        - file: /etc/apt/sources.list.d/php.list
        - keyid: E5267A6C
        - keyserver: keyserver.ubuntu.com
        - require_in:
            - pkg: apache2
            - pkg: php

php:
    pkg.installed:
        - name: php7.0
        - pkgrepo: php_ppa
        - require:
            - pkgrepo: php_ppa

php-packages:
    pkg.installed:
        - pkgs:
            - libapache2-mod-php7.0
            - php-apcu
            - php-apcu-bc
            - php-curl
            - php-gd
            - php-intl
            - php-mbstring
            - php-memcached
            - php-pgsql
            - php-xml
            - php-zip
            - php-xdebug
        - require:
            - pkg: php

{% set files = {
    '/etc/php/7.0/apache2/php.ini': 'salt://php/config/apache2.ini',
    '/etc/php/7.0/apache2/conf.d/05-shared.ini': 'salt://php/config/shared.ini',
    '/etc/php/7.0/apache2/conf.d/10-dev.ini': 'salt://php/config/dev.ini',
    '/etc/php/7.0/cli/php.ini': 'salt://php/config/cli.ini',
    '/etc/php/7.0/cli/conf.d/05-shared.ini': 'salt://php/config/shared.ini',
    '/etc/php/7.0/cli/conf.d/10-dev.ini': 'salt://php/config/dev.ini',
} %}
{% for file, source in files.iteritems() %}
{{ file }}:
    file.managed:
        - source: {{ source }}
        - mode: 644
        - require:
            - pkg: php-packages
{% endfor %}

/etc/php/7.0/cli/conf.d/20-xdebug.ini:
    file.absent:
        - require:
            - pkg: php-dev-packages
