FROM ubuntu:14.04

ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive
RUN groupadd sentry && useradd --create-home --home-dir /home/sentry -g sentry sentry
WORKDIR /home/sentry

RUN rm /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get install libmysqlclient-dev python-pip python-dev build-essential -y

# If you change this, you'll also need to install the appropriate python
# package:
RUN pip install mysql-python -i http://mirrors.aliyun.com/pypi/simple/

# You'll need to install the required dependencies for Redis buffers:
RUN pip install redis hiredis nydus -i http://mirrors.aliyun.com/pypi/simple/

ENV SENTRY_VERSION 8.0.0rc1

RUN pip install sentry==$SENTRY_VERSION -i http://mirrors.aliyun.com/pypi/simple/

RUN mkdir -p /home/sentry/.sentry \
	&& chown -R sentry:sentry /home/sentry/.sentry

# COPY docker-links.conf.py /home/sentry/
# COPY docker-entrypoint.sh /

RUN echo "export TERM=xterm" >> ~/.bashrc
RUN echo "export DEBIAN_FRONTEND=noninteractive" >> ~/.bashrc

USER sentry
EXPOSE 9000

# ENTRYPOINT ["/docker-entrypoint.sh"]
ENV SENTRY_CONF /etc/sentry/sentry.conf.py
CMD ["sentry", "start"]
