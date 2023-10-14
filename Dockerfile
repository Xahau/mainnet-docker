FROM --platform=linux/x86_64 jrei/systemd-ubuntu:22.04

RUN apt-get update && systemctl enable systemd-user-sessions.service && \
    apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y && \
    apt-get install -y jq sudo wget gpg curl nano htop ucommon-utils openssh-server jq inetutils-ping passwd && \
    mkdir /var/run/sshd && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    rm -rf /var/lib/apt/lists/*

# echo 'user:newpass' | chpasswd && \

ENV NOTVISIBLE "in users profile"

RUN echo "export VISIBLE=now" >> /etc/profile && rm -f /run/nologin

ADD store /opt/xahaud
ADD utilities/validator-keys /bin/
COPY xahaud-install-update.sh /xahaud-install-update.sh

RUN chmod +x /xahaud-install-update.sh && \
    /bin/bash /xahaud-install-update.sh && \
    systemctl enable xahaud.service

EXPOSE 22 80 8080 21338 15005 16005 16006 16007
