FROM python:3.10-slim-buster

# prepare OS
ENV DEBIAN_FRONTEND noninteractive
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl git cron docker.io && \
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \
    DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y kubectl

# prepare CICD account
RUN mkdir /root/.ssh && \
    chmod 0700 /root/.ssh
ADD id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan 192.168.1.104 >> /root/.ssh/known_hosts
RUN chmod 600 /root/.ssh/known_hosts

# prepare kubernetes config
ADD config /root/.kube/config

# build
WORKDIR /work
ADD build.sh /work/build.sh

# first run
#RUN /bin/bash /work/build.sh >> /work/build.log 2>&1
RUN echo "CICD container deployed" >> /work/build.log

# schedule build to cron
RUN (echo "* * * * * /bin/bash /work/build.sh >> /work/build.log 2>&1") | crontab
ENTRYPOINT cron && tail -f /work/build.log




