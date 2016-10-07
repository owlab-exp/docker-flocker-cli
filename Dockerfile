FROM owlab/alpine-su-exec:3.4-0.2
MAINTAINER Hun Jae Lee <hunjae.lee@gmail.com>

RUN apk add --update --no-cache python py-virtualenv 
RUN apk add --no-cache --virtual build-deps gcc libffi-dev openssl-dev python-dev \
# To avoid upcoming errors at the last flocker install phase!
    linux-headers musl-dev g++ ca-certificates \
    && update-ca-certificates \
# Install flocker-client
    && virtualenv --python=/usr/bin/python2.7 flocker-client \
    && source flocker-client/bin/activate \
    && pip install --upgrade pip \
    && pip install https://clusterhq-archive.s3.amazonaws.com/python/Flocker-1.15.0-py2-none-any.whl \
    && rm -rf ~/.cache/pip \
# Uninstall unneeded packages
    && apk del build-deps \
# To make start script
    && echo "#!/bin/sh" > /usr/local/bin/entrypoint.sh \
    && echo "USER_ID=\${LOCAL_USER_ID:-9001}" >> /usr/local/bin/entrypoint.sh \
    && echo "adduser -D -u \$USER_ID -g \"\" user " >> /usr/local/bin/entrypoint.sh \
    && echo "chown user /flockercerts " >> /usr/local/bin/entrypoint.sh \
    && echo "source /flocker-client/bin/activate && su-exec user flocker-ca \$@" >> /usr/local/bin/entrypoint.sh \
    && chmod 755 /usr/local/bin/entrypoint.sh \
    && mkdir flockercerts

WORKDIR /flockercerts
VOLUME /flockercerts

ENTRYPOINT ["entrypoint.sh"]
