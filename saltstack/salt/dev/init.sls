curl:
    pkg.installed

dev-packages:
    pkg.installed:
        - pkgs:
            - bash-completion
            - bsd-mailx
            - build-essential
            - g++
            - git
            - make
            - nano
            - postgresql-9.3
            - vim
            - wget
        - require:
            - pkg: curl

ssh:
    pkg.installed:
        - name: openssh-server
    service.running:
        - watch:
            - pkg: openssh-server
            - file: /etc/ssh/*

{{ pillar['user']['group'] }}:
    group:
        - present
    user:
        - present
        - uid: 1000
        - gid: {{ pillar['user']['group'] }}
        - shell: /bin/bash
        - home: /home/{{ pillar['user']['user'] }}
        - groups:
            - sudo
            - {{ pillar['user']['group'] }}
        - require:
            - group: {{ pillar['user']['group'] }}

dev-user-git-prompt:
    file.append:
        - name: /home/dev/.bashrc
        - text: 'PS1="\[\033[32;1m\]\u@\h\[\033[00m\]: \[\033[34;1m\]\w\[\033[31;1m\]\$(__git_ps1)\[\033[00m\] \$ "'
        - require:
            - user: {{ pillar['user']['user'] }}

dev-user-start-in-app-dir:
    file.append:
        - name: /home/dev/.bashrc
        - text: cd /var/www/app.dev
        - require:
            - user: {{ pillar['user']['user'] }}

dev-user-ssh-key:
    ssh_auth.present:
        - user: dev
        - source: salt://dev/supervisor
        - require:
            - user: {{ pillar['user']['user'] }}

/home/dev/.ssh/config:
    file.managed:
        - source: salt://dev/ssh/config
        - user: {{ pillar['user']['user'] }}
        - group: {{ pillar['user']['group'] }}
        - makedirs: true
        - mode: 600
        - require:
            - user: {{ pillar['user']['user'] }}

dev-user-sudo-without-password:
    file.append:
        - name: /etc/sudoers
        - text: 'dev ALL=(ALL)  NOPASSWD: ALL'
        - require:
            - user: {{ pillar['user']['user'] }}

/etc/supervisor/conf.d:
    file.recurse:
        - source: salt://dev/supervisor
        - template: jinja
        - clean: true
        - require:
            - pkg: supervisor
            - pkg: gearman
            - gem: mailcatcher
            - file: selenium

service supervisor start > /dev/null:
    cron.present:
        - identifier: supervisor
        - require:
            - pkg: supervisor
