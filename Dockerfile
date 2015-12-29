FROM ubuntu:14.04

ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive
RUN groupadd sentry && useradd --create-home --home-dir /home/sentry -g sentry sentry
WORKDIR /home/sentry

RUN apt-get update -y
RUN apt-get install libmysqlclient-dev -y

# If you change this, you'll also need to install the appropriate python
# package:
RUN pip install mysql-python 

# You'll need to install the required dependencies for Memcached:
RUN pip install python-memcached

# You'll need to install the required dependencies for Redis buffers:
RUN pip install redis hiredis nydus

ENV SENTRY_VERSION 8.0.0rc1

RUN pip install sentry==$SENTRY_VERSION

RUN mkdir -p /home/sentry/.sentry \
	&& chown -R sentry:sentry /home/sentry/.sentry

COPY docker-links.conf.py /home/sentry/
COPY docker-entrypoint.sh /

USER sentry
EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sentry", "start"]
