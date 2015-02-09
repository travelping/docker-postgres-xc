FROM ubuntu:14.04

MAINTAINER umatomba@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y build-essential libreadline-dev zlib1g-dev flex bison wget vim

RUN mkdir /postgres/log/ -p

ENV VERSION 1.2.1
ENV INSTALL_DIR /opt/postgres-xc
ENV DATA_DIR /postgres
ENV LOG_DIR /postgres/log/

RUN wget -O /tmp/pgxc.tar.gz http://downloads.sourceforge.net/project/postgres-xc/Version_1.2/pgxc-v1.2.1.tar.gz 
RUN cd /tmp && tar -xzvf pgxc.tar.gz
RUN cd /tmp/postgres-xc-1.2.1 && ./configure --enable-debug && make && make install

RUN adduser --disabled-password --gecos '' postgres
RUN adduser postgres sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown -R postgres:postgres /postgres
RUN sed -i "s/^#\ rc.local.*/\/home\/postgres\/hosts.sh/" "/etc/rc.local"

#USER postgres
ENV PATH /usr/local/pgsql/bin:$PATH
ADD files/postgresql.conf /home/postgres/postgresql.conf
ADD files/gtm.conf /home/postgres/gtm.conf
ADD files/pg_hba.conf /home/postgres/pg_hba.conf
ADD files/init_coord.sh /home/postgres/init_coord.sh
ADD files/init_datanode.sh /home/postgres/init_datanode.sh
ADD files/init_gtmm.sh /home/postgres/init_gtmm.sh
ADD files/init_gtms.sh /home/postgres/init_gtms.sh

RUN chmod +x /home/postgres/*.sh

VOLUME /postgres

EXPOSE 5432 6666