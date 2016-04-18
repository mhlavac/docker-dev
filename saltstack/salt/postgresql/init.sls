postgresql:
    pkgrepo.managed:
        - humanname: Postgresql
        - name: deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main
        - dist: precise-pgdg
        - file: /etc/apt/sources.list.d/postgresql.list
        - keyid: ACCC4CF8
        - keyserver: keyserver.ubuntu.com
        - require_in:
            - pkg: postgresql
    pkg:
        - installed
        - names:
            - postgresql-9.3
            - postgresql-client-common

/etc/postgresql/9.3/main/pg_hba.conf:
    file.managed:
        - source: salt://postgresql/config/pg_hba.conf
        - require:
            - pkg: postgresql

/etc/postgresql/9.3/main/postgresql.conf:
    file.managed:
        - source: salt://postgresql/config/postgresql.conf
        - require:
            - pkg: postgresql

postgres_user:
    postgres_user.present:
        - name:  {{ pillar['postgresql']['user'] }}
        - password:  {{ pillar['postgresql']['password'] }}
        - createdb: true
        - createroles: true
        - superuser: true
        - require:
            - pkg: postgresql

postgres_db:
    postgres_database.present:
        - name: app
        - encoding: UTF8
        - lc_ctype: en_US.UTF8
        - lc_collate: en_US.UTF8
        - template: template0
        - owner: {{ pillar['postgresql']['user'] }}
        - require:
            - postgres_user: postgres_user
