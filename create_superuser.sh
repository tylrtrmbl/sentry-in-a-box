#!/bin/sh

set -e

/etc/init.d/postgresql start

echo "A new admin user with username 'sentry' will be created."
sentry --config=/etc/sentry.conf.py createsuperuser --username sentry
sentry --config=/etc/sentry.conf.py repair --owner=sentry

/etc/init.d/postgresql stop
