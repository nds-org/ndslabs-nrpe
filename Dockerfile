FROM ubuntu:xenial

RUN apt-get update -y && \
    apt-get install -y nagios-plugins nagios-nrpe-server 

EXPOSE 5666

COPY nrpe.cfg /etc/nagios/nrpe.cfg
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nrpe"]
