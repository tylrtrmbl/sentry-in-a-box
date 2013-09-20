#!/bin/sh

set -e

/etc/init.d/postgresql start

/etc/init.d/nginx start
supervisord -c /etc/supervisord.conf

/bin/bash

/etc/init.d/postgresql stop
