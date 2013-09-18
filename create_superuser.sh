#!/bin/sh

set -e

/etc/init.d/postgresql start

echo "A new admin user with username 'sentry' will be created."

# create a new user
sentry --config=/etc/sentry.conf.py createsuperuser --username sentry

# run the automated repair script
sentry --config=/etc/sentry.conf.py repair --owner=sentry

/etc/init.d/postgresql stop
