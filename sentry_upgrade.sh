#!/bin/sh

set -e

/etc/init.d/postgresql start

sentry --config=/etc/sentry.conf.py upgrade --noinput

/etc/init.d/postgresql stop
