FROM daocloud.io/centos:7.2.1511
MAINTAINER yedaodao <404069912@qq.com>

ENV DEV_DATA_PATH /var/dev-data

COPY ./resolv.conf /etc/
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i ==
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
RUN yum install -y net-tools;
RUN yum install -y wget;
RUN yum install -y openssh-server
COPY ./sshd_config /etc/ssh/
RUN systemctl enable sshd.service
RUN systemctl start sshd.service

RUN mkdir -p $DEV_DATA_PATH;

WORKDIR $DEV_DATA_PATH;
VOLUME [$DEV_DATA_PATH]
VOLUME ["/sys/fs/cgroup"]

CMD ["/usr/sbin/init","/bin/bash"]
