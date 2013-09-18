#!/bin/sh

set -e

/etc/init.d/postgresql start

nginx
supervisord -c /etc/supervisord.conf

/bin/bash

/etc/init.d/postgresql stop
