#!/bin/bash

if [ "$1" = 'nrpe' ]; then
    service nagios-nrpe-server start
    sleep infinity
else
   exec "$@"
fi
