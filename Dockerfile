FROM alpine:3.4
MAINTAINER Hun Jae Lee <hunjae.lee@gmail.com>

RUN apk add --update --no-cache gcc libffi-dev openssl-dev python python-dev py-virtualenv \
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
    && apk del gcc libffi-dev openssl-dev python-dev linux-headers musl-dev g++

# To make start script
RUN echo "#!/bin/sh" > /usr/local/bin/entrypoint.sh \
    && echo "source /flocker-client/bin/activate && flocker-ca \$@" >> /usr/local/bin/entrypoint.sh \
    && chmod 755 /usr/local/bin/entrypoint.sh \
    && mkdir flockercerts

WORKDIR /flockercerts
VOLUME /flockercerts

ENTRYPOINT ["entrypoint.sh"]
