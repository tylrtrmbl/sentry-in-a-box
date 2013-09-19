#!/bin/sh

set -e

/etc/init.d/postgresql start

service nginx start
supervisord -c /etc/supervisord.conf --nodaemon

/etc/init.d/postgresql stop
