FROM centos/systemd
RUN yum install -y openssh-server sudo && \
  systemctl enable sshd.service
