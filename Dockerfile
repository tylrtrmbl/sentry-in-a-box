# Sentry
#
# VERSION 0.1

FROM ubuntu:12.04
MAINTAINER tylrtrmbl <taylor@thenewtricks.com>

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -q -y update

# Install nginx, Python, and supervisord
RUN apt-get -q -y install nginx python-setuptools python-dev python-pip
RUN easy_install supervisor

# Install Postgres
RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d # Prevent Postgres from starting
RUN apt-get -q -y install postgresql postgresql-contrib libpq-dev && rm /usr/sbin/policy-rc.d

# Install uWSGI
RUN pip install uWSGI

# Install specific common tools
RUN apt-get -q -y install curl make

# Install Sentry
RUN easy_install -UZ sentry sentry[postgres]

# Install Redis for Sentry
RUN mkdir /root/redis-stable && curl -L http://download.redis.io/redis-stable.tar.gz | tar xvz --strip-components=1 --directory=/root/redis-stable
RUN cd /root/redis-stable && make && cp /root/redis-stable/src/redis-server /usr/local/bin/redis-server
RUN pip install redis hiredis nydus

# Configure nginx
ADD config/nginx_sentry /etc/nginx/sites-available/sentry

# Configure supervisord
ADD config/supervisord_programs.conf /etc/supervisord_programs.conf
RUN echo_supervisord_conf > /etc/supervisord.conf && cat /etc/supervisord_programs.conf >> /etc/supervisord.conf

# Add configuration files to uWSGI
ADD config/uwsgi_sentry.ini /etc/uwsgi_sentry.ini

# Configure Sentry
ADD config/sentry.conf.py /etc/sentry.conf.py
ADD scripts/configure_sentry.sh /root/configure_sentry.sh
ADD scripts/create_sentry_superuser.py /root/create_sentry_superuser.py
RUN chmod a+x /root/configure_sentry.sh && /root/configure_sentry.sh

# Add run script
ADD run.sh /root/run.sh
RUN chmod a+x /root/run.sh

CMD ["/root/run.sh"]
