FROM mhlavac/docker-ubuntu-saltstack:latest
MAINTAINER Martin Hlavac <info@mhlavac.net>

ADD saltstack/salt /salstack/salt
ADD saltstack/pillar /salstack/pillar
RUN salt-call --retcode-passthrough --local state.highstate

# Clear some caches
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/cache/* && \
    rm -rf /var/lib/log/*

CMD ["/sbin/init"]
