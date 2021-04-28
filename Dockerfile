FROM oraclelinux:8-slim
ARG MYSQLD_URL=https://repo.mysql.com/yum/mysql-8.0-community/docker/el/8/x86_64/mysql-community-server-minimal-8.0.24-1.el8.x86_64.rpm
ARG ROUTER_URL=https://repo.mysql.com/yum/mysql-tools-community/el/8/x86_64/mysql-router-community-8.0.24-1.el8.x86_64.rpm
ARG SHELL_URL=https://repo.mysql.com/yum/mysql-tools-community/el/8/x86_64/mysql-shell-8.0.24-1.el8.x86_64.rpm

# Install server
RUN rpmkeys --import http://repo.mysql.com/RPM-GPG-KEY-mysql \
  && microdnf install yum \
  && yum install -y $MYSQLD_URL \
  && yum install -y $ROUTER_URL \
  && yum install -y $SHELL_URL \
  && yum install -y libpwquality \
  && yum install -y hostname \
  && yum install -y less vim-minimal net-tools \
  && rm -rf /var/cache/yum/*
RUN mkdir /docker-entrypoint-initdb.d

ADD my.cnf /etc/mysql/my.cnf 

VOLUME /var/lib/mysql
VOLUME /var/lib/mysqlrouter

COPY innodb_cluster-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY healthcheck.sh /healthcheck.sh
HEALTHCHECK --start-period=60s --timeout=15s --interval=10s --retries=2 CMD /healthcheck.sh

#EXPOSE 3306 6606 6446 6447 33060
CMD [""]

