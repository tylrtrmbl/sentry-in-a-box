#!/bin/sh

set -e
export SENTRY_CONF=/etc/sentry.conf.py

/etc/init.d/postgresql start

# Initialize the Postgres database
su postgres sh -c "psql -c \"CREATE ROLE sentry LOGIN password 'sentry';\""
su postgres sh -c "psql -c \"CREATE DATABASE sentry OWNER sentry ENCODING 'UTF8' TEMPLATE template0;\""

# Migrate and upgrade sentry
sentry upgrade --noinput

# Create the base superuser
pip install logan==0.5.8.2 # HACK: @dcramer did me a solid it seems. Thanks, man!
python /root/create_superuser.py
echo "Done with that superuser."
sentry repair --owner=fancy_admin

/etc/init.d/postgresql stop
