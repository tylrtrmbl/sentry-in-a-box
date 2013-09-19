#!/usr/bin/env python

# Bootstrap the Sentry environment
from sentry.utils.runner import configure
configure()

# Add default superuser
from sentry.models import User

user = User()
user.username = 'fancy_admin'
user.email = 'fancy@example.com'
user.is_superuser = True
user.set_password('supersecretpasswordillnevertellyou')
user.save()
