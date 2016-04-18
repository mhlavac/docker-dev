{% set adminer_index_file = '/var/www/adminer.dev/index.php' %}

adminer-index:
    file.managed:
        - name: {{ adminer_index_file }}
        - source: salt://adminer/index.php
        - template: jinja
        - user:  {{ pillar['user']['user'] }}
        - group: {{ pillar['user']['group'] }}
        - require:
            - file: adminer

adminer:
    file.managed:
        - name: /var/www/adminer.dev/adminer.php
        - source: https://www.adminer.org/static/download/4.2.3/adminer-4.2.3-en.php
        - source_hash: sha1=12e0fbce96c628dbcebedf03e496eec119fc8d98
        - makedirs: true
        - user: {{ pillar['user']['user'] }}
        - group: {{ pillar['user']['group'] }}
        - require:
            - pkg: apache2
            - user: {{ pillar['user']['user'] }}
        - unless: test -e {{ adminer_index_file }}
