FROM centos:7

RUN yum -y update && yum install -y haproxy rsyslog && yum clean all

COPY entrypoint /usr/bin/entrypoint
CMD [ "/usr/bin/entrypoint", "-f", "/usr/local/etc/haproxy/haproxy.cfg" ]
