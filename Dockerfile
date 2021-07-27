FROM centos/systemd
RUN yum install -y openssh-server && \
  systemctl enable sshd.service
