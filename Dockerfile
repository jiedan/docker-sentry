FROM ubuntu:14.04

RUN groupadd sentry && useradd --create-home --home-dir /home/sentry -g sentry sentry
WORKDIR /home/sentry

# If you change this, you'll also need to install the appropriate python
# package:
RUN pip install psycopg2 mysql-python

# You'll need to install the required dependencies for Memcached:
RUN pip install python-memcached

# You'll need to install the required dependencies for Redis buffers:
RUN pip install redis hiredis nydus

ENV SENTRY_VERSION 7.7.0

RUN pip install sentry==$SENTRY_VERSION

RUN mkdir -p /home/sentry/.sentry \
	&& chown -R sentry:sentry /home/sentry/.sentry

COPY docker-links.conf.py /home/sentry/
COPY docker-entrypoint.sh /

USER sentry
EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sentry", "start"]
