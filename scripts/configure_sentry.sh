#!/bin/sh

set -e
export SENTRY_CONF=/etc/sentry.conf.py

SUPERUSER_USERNAME=admin
SUPERUSER_EMAIL=admin@example.com
SUPERUSER_PASSWORD=root

/etc/init.d/postgresql start

# Initialize the Postgres database
su postgres sh -c "psql -c \"CREATE ROLE sentry LOGIN password 'sentry';\""
su postgres sh -c "psql -c \"CREATE DATABASE sentry OWNER sentry ENCODING 'UTF8' TEMPLATE template0;\""

# Migrate and upgrade sentry
sentry upgrade --noinput

# Create the base superuser
python /root/create_sentry_superuser.py $SUPERUSER_USERNAME $SUPERUSER_EMAIL $SUPERUSER_PASSWORD
sentry repair --owner=$SUPERUSER_USERNAME

/etc/init.d/postgresql stop
