# Sentry
#
# VERSION 0.1

FROM ubuntu:12.04
MAINTAINER tylrtrmbl <taylor@thenewtricks.com>

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -q -y update

# Install Python tools
RUN apt-get -q -y install python-setuptools python-dev
RUN easy_install pip

# Install Postgres
RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d # Prevent Postgres from starting on installation
RUN chmod +x /usr/sbin/policy-rc.d
RUN apt-get -q -y install postgresql-9.1 postgresql-contrib-9.1 libpq-dev
RUN rm /usr/sbin/policy-rc.d

# Install uWSGI
RUN pip install uWSGI

# Install Sentry
RUN easy_install -UZ sentry
RUN easy_install -UZ sentry[postgres]

# Install Redis for Sentry
RUN pip install redis hiredis nydus

# Initialize the Postgres db
ADD db_fence.sh /root/db_fence.sh
RUN chmod a+x /root/db_fence.sh
ADD init_db.sh /root/init_db.sh
RUN chmod a+x /root/init_db.sh
RUN /root/db_fence.sh /root/init_db.sh

# Configure Sentry
ADD sentry.conf.py /etc/sentry.conf.py
ADD sentry_upgrade.sh /root/sentry_upgrade.sh
RUN chmod a+x /root/sentry_upgrade.sh
RUN /root/db_fence.sh /root/sentry_upgrade.sh

# No superuser is created by default!
# YOU HAVE TO DO THIS YOURSELF!!!!!!!
# You can use the /root/create_superuser script for this
ADD create_superuser.sh /root/create_superuser.sh
RUN chmod a+x /root/create_superuser.sh

# Add configuration files to uWSGI
ADD sentry.ini /etc/sentry.ini
ADD uwsgid.sh /root/uwsgid.sh
RUN chmod a+x /root/uwsgid.sh

CMD ["/root/create_superuser.sh"]
