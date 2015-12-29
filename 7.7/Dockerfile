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

ENV SENTRY_VERSION 7.7.4

RUN pip install --no-cache-dir  sentry==$SENTRY_VERSION -i http://mirrors.aliyun.com/pypi/simple/

RUN echo "export TERM=xterm" >> ~/.bashrc
RUN echo "export DEBIAN_FRONTEND=noninteractive" >> ~/.bashrc

RUN mkdir -p /home/user/.sentry \
	&& chown -R user:user /home/user/.sentry

COPY docker-links.conf.py /home/user/
COPY docker-entrypoint.sh /

USER user
EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sentry", "start"]
