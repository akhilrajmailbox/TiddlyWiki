FROM ubuntu:16.04
MAINTAINER Akhil Raj <akhilrajmailbox@gmail.com>

RUN sed -i "s|deb http://security.ubuntu.com/ubuntu/ xenial-security universe|#deb http://security.ubuntu.com/ubuntu/ xenial-security universe|g" /etc/apt/sources.list
RUN sed -i "s|deb-src http://security.ubuntu.com/ubuntu/ xenial-security universe|#deb-src http://security.ubuntu.com/ubuntu/ xenial-security universe|g" /etc/apt/sources.list
RUN apt-get update
RUN apt-get install nodejs npm nano apache2 libldap-2.4-2 iputils-ping -y
RUN npm install -g tiddlywiki
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN tiddlywiki /opt/TiddlyWiki --init server

RUN cp -r /etc/apache2 /root/apache2
RUN cp -r /opt/TiddlyWiki /root/TiddlyWiki

ADD tiddly-apache-start.sh /root/start.sh
RUN chmod a+x /root/start.sh

ENTRYPOINT "/root/start.sh"
