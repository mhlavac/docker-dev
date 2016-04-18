php-composer-get:
    cmd.run:
        - name: 'curl -sS https://getcomposer.org/installer | php'
        - unless: test -f /usr/local/bin/composer
        - cwd: /root/
        - require:
            - pkg: php-packages
            - pkg: curl

php-composer-install:
    cmd.wait:
        - name: 'mv /root/composer.phar /usr/local/bin/composer'
        - cwd: /root/
        - watch:
            - cmd: php-composer-get

php-composer-set-token:
    cmd.wait:
        - name: '/usr/local/bin/composer config -g github-oauth.github.com {{ pillar['php.composer']['token'] }}
        - user: dev
        - group: dev
        - watch:
            - cmd: php-composer-install
        - require:
            - user: {{ pillar['user']['user'] }}
            - group: {{ pillar['user']['group'] }}

{# composer global require hirak/prestissimo, makes composer install so much faster! #}
composer-prestissimo:
    cmd.run:
        - name: composer global require "hirak/prestissimo"
        - user: dev
        - require:
            - pkg: php-dev-packages
            - user: {{ pillar['user']['user'] }}

composer-changelogs:
    cmd.run:
        - name: composer global require "pyrech/composer-changelogs"
        - user: dev
        - require:
            - pkg: php-dev-packages
            - user: {{ pillar['user']['user'] }}
