# This file is just Python, with a touch of Django which means you
# you can inherit and tweak settings to your hearts content.
from sentry.conf.server import *

import os.path

DATABASES = {
    'default': {
        # You can swap out the engine for MySQL easily by changing this value
        # to ``django.db.backends.mysql`` or to PostgreSQL with
        # ``django.db.backends.postgresql_psycopg2``

        # If you change this, you'll also need to install the appropriate python
        # package: psycopg2 (Postgres) or mysql-python
        'ENGINE': 'django.db.backends.postgresql_psycopg2',

        'NAME': 'sentry',
        'USER': 'sentry',
        'PASSWORD': 'sentry',
        'HOST': 'localhost',
        'PORT': '',

        # If you're using Postgres, we recommend turning on autocommit
        'OPTIONS': {
            'autocommit': True,
        }
    }
}


# If you're expecting any kind of real traffic on Sentry, we highly recommend
# configuring the CACHES and Redis settings

###########
## CACHE ##
###########

# You'll need to install the required dependencies for Memcached:
#   pip install python-memcached
#
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': ['127.0.0.1:11211'],
    }
}

###########
## Queue ##
###########

# See http://sentry.readthedocs.org/en/latest/queue/index.html for more
# information on configuring your queue broker and workers. Sentry relies
# on a Python framework called Celery to manage queues.

# You can enable queueing of jobs by turning off the always eager setting:
CELERY_ALWAYS_EAGER = False
BROKER_URL = 'redis://localhost:6379'

####################
## Update Buffers ##
####################

# Buffers (combined with queueing) act as an intermediate layer between the
# database and the storage API. They will greatly improve efficiency on large
# numbers of the same events being sent to the API in a short amount of time.
# (read: if you send any kind of real data to Sentry, you should enable buffers)

# You'll need to install the required dependencies for Redis buffers:
#   pip install redis hiredis nydus
#
SENTRY_BUFFER = 'sentry.buffer.redis.RedisBuffer'
SENTRY_REDIS_OPTIONS = {
    'hosts': {
        0: {
            'host': '127.0.0.1',
            'port': 6379,
        }
    }
}

################
## Web Server ##
################

# You MUST configure the absolute URI root for Sentry:
SENTRY_URL_PREFIX = 'http://example.com'  # No trailing slash!

# If you're using a reverse proxy, you should enable the X-Forwarded-Proto
# header, and uncomment the following setting
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

#################
## Mail Server ##
#################

# For more information check Django's documentation:
#  https://docs.djangoproject.com/en/1.3/topics/email/?from=olddocs#e-mail-backends

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'

EMAIL_HOST = 'smtp.mailgun.org'
EMAIL_HOST_PASSWORD = '847D132F-6E48-4A5C-AB62-357F3A312143'
EMAIL_HOST_USER = 'postmaster@example.com'
EMAIL_PORT = 25
EMAIL_USE_TLS = False

# The email address to send on behalf of
SERVER_EMAIL = 'sentry@example.com'

###########
## etc. ##
###########

# If this file ever becomes compromised, it's important to regenerate your SECRET_KEY
# Changing this value will result in all current sessions being invalidated
SECRET_KEY = '4BCB5779-245D-49A5-8893-B745E62C52BF'

# We should have to invite users!
SENTRY_ALLOW_REGISTRATION = False
