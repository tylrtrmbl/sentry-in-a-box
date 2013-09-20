#!/usr/bin/env python

import sys

# Bootstrap the Sentry environment
from sentry.utils.runner import configure
configure()

# Add default superuser
from sentry.models import User

user = User()
user.username = sys.argv[1]
user.email = sys.argv[2]
user.is_superuser = True
user.set_password(sys.argv[3])
user.save()
