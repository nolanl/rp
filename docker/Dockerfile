FROM debian:bullseye-slim
ARG UNAME=testuser
ARG UID=1000
ARG GID=1000

RUN    apt-get update \
    && apt-get install -y --no-install-recommends \
    openssh-server rsync git \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g $GID -o $UNAME \
    && useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

CMD bash -c "/etc/init.d/ssh start; echo SSH_UP; sleep 1800"
