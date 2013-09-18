#!/bin/sh

set -e

/etc/init.d/postgresql start

sh $1

/etc/init.d/postgresql stop
