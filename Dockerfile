ARG BASE_TAG="1.15.0"
ARG BASE_IMAGE="kasmweb/ubuntu-jammy-desktop"
FROM $BASE_IMAGE:$BASE_TAG

USER root

# 更新软件包并安装所需软件
RUN apt-get update && apt upgrade -y \
    && apt-get install -y netcat htop socat iputils-ping openssh-server cron \
    && echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && rm -rf /var/lib/apt/lists/*

# 插入命令到 /dockerstartup/vnc_startup.sh 中的 # start processes 行下
RUN sed -i '/# start processes/a \
echo root:${VNC_PW} | sudo chpasswd root && sudo sed -i "s/^#\\?PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && sudo sed -i "s/^#\\?PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config && sudo service ssh restart' /dockerstartup/vnc_startup.sh


# 切换回非root用户
USER 1000