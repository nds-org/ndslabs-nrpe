FROM ubuntu:xenial

RUN apt-get update -y && \
    apt-get install -y nagios-plugins nagios-nrpe-server 

EXPOSE 5666

COPY nrpe.cfg /etc/nagios/nrpe.cfg
COPY nrpe-entrypoint.sh /nrpe-entrypoint.sh
ENTRYPOINT ["/nrpe-entrypoint.sh"]
CMD ["nrpe"]
