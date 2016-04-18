ruby_ppa:
    pkgrepo.managed:
        - humanname: Ruby
        - name: deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main
        - dist: trusty
        - file: /etc/apt/sources.list.d/ruby.list
        - keyid: C3173AA6
        - keyserver: keyserver.ubuntu.com

ruby:
    pkg.installed:
        - name: ruby2.3
        - pkgs:
            - ruby2.3
            - ruby2.3-dev
        - require:
            - pkgrepo: ruby_ppa
            - pkg: dev-packages

mailcatcher:
     gem.installed:
        - require:
            - pkg: ruby
