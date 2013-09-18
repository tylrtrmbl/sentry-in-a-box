#!/bin/sh

set -e

/etc/init.d/postgresql start

su postgres sh -c "psql -c \"CREATE ROLE sentry LOGIN password 'sentry';\""
su postgres sh -c "psql -c \"CREATE DATABASE sentry OWNER sentry ENCODING 'UTF8' TEMPLATE template0;\""

/etc/init.d/postgresql stop