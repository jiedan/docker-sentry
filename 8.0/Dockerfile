FROM ubuntu:14.04

ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive

RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get install libmysqlclient-dev python-pip python-dev build-essential -y
RUN apt-get install libxslt1-dev libxml2-dev libz-dev libffi-dev libssl-dev libpq-dev libyaml-dev -y

# If you change this, you'll also need to install the appropriate python
# package:
RUN pip install mysql-python -i http://mirrors.aliyun.com/pypi/simple/

# You'll need to install the required dependencies for Redis buffers:
RUN pip install redis hiredis nydus -i http://mirrors.aliyun.com/pypi/simple/

ENV SENTRY_VERSION 8.0.0rc1

RUN pip install sentry==$SENTRY_VERSION -i http://mirrors.aliyun.com/pypi/simple/

RUN echo "export TERM=xterm" >> ~/.bashrc
RUN echo "export DEBIAN_FRONTEND=noninteractive" >> ~/.bashrc

ENV SENTRY_CONF /etc/sentry
ENV SENTRY_FILESTORE_DIR /var/lib/sentry/files
RUN mkdir -p $SENTRY_CONF && mkdir -p $SENTRY_FILESTORE_DIR

COPY sentry.conf.py /etc/sentry/
COPY config.yml /etc/sentry/

# Allow Celery to run as root
ENV C_FORCE_ROOT 1

COPY docker-entrypoint.sh /

EXPOSE 9000
VOLUME /var/lib/sentry/files

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
