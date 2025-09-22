# Dockerfile
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y openssh-server sudo ca-certificates procps iproute2 \
 && mkdir -p /var/run/sshd /etc/ctx /seed/ctx \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
COPY deploy_ctx.sh /usr/local/bin/deploy_ctx.sh
COPY user_list.txt /etc/ctx/users.txt

RUN chmod +x /start.sh /usr/local/bin/deploy_ctx.sh

EXPOSE 22
ENTRYPOINT ["/start.sh"]
